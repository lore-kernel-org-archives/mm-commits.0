From: akpm@linux-foundation.org
Subject: [patch 15/15] scripts/gdb: make lx-dmesg command work (reliably)
Date: Fri, 02 Jun 2017 14:46:51 -0700
Message-ID: <5931dccb.dBIGP5o/I8IDt29M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51578 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBVqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2017 17:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, git@andred.net, jan.kiszka@siemens.com, kieran@ksquared.org.uk

From: André Draszik <git@andred.net>
Subject: scripts/gdb: make lx-dmesg command work (reliably)

lx-dmesg needs access to the log_buf symbol from printk.c.  Unfortunately,
the symbol log_buf also exists in BPF's verifier.c and hence gdb can pick
one or the other.  If it happens to pick BPF's log_buf, lx-dmesg doesn't
work:

  (gdb) lx-dmesg
  Python Exception <class 'gdb.MemoryError'> Cannot access memory at address 0x0:
  Error occurred in Python command: Cannot access memory at address 0x0
  (gdb) p log_buf
  $15 = 0x0

Luckily, GDB has a way to deal with this, see
  https://sourceware.org/gdb/onlinedocs/gdb/Symbols.html

  (gdb) info variables ^log_buf$
  All variables matching regular expression "^log_buf$":

  File <linux.git>/kernel/bpf/verifier.c:
  static char *log_buf;

  File <linux.git>/kernel/printk/printk.c:
  static char *log_buf;
  (gdb) p 'verifier.c'::log_buf
  $1 = 0x0
  (gdb) p 'printk.c'::log_buf
  $2 = 0x811a6aa0 <__log_buf> ""
  (gdb) p &log_buf
  $3 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'verifier.c'::log_buf
  $4 = (char **) 0x8120fe40 <log_buf>
  (gdb) p &'printk.c'::log_buf
  $5 = (char **) 0x8048b7d0 <log_buf>

By being explicit about the location of the symbol, we can make lx-dmesg
work again.  While at it, do the same for the other symbols we need from
printk.c

Link: http://lkml.kernel.org/r/20170526112222.3414-1-git@andred.net
Signed-off-by: André Draszik <git@andred.net>
Tested-by: Kieran Bingham <kieran@bingham.xyz>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/gdb/linux/dmesg.py |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN scripts/gdb/linux/dmesg.py~scripts-gdb-make-lx-dmesg-command-work-reliably scripts/gdb/linux/dmesg.py
--- a/scripts/gdb/linux/dmesg.py~scripts-gdb-make-lx-dmesg-command-work-reliably
+++ a/scripts/gdb/linux/dmesg.py
@@ -23,10 +23,11 @@ class LxDmesg(gdb.Command):
         super(LxDmesg, self).__init__("lx-dmesg", gdb.COMMAND_DATA)
 
     def invoke(self, arg, from_tty):
-        log_buf_addr = int(str(gdb.parse_and_eval("log_buf")).split()[0], 16)
-        log_first_idx = int(gdb.parse_and_eval("log_first_idx"))
-        log_next_idx = int(gdb.parse_and_eval("log_next_idx"))
-        log_buf_len = int(gdb.parse_and_eval("log_buf_len"))
+        log_buf_addr = int(str(gdb.parse_and_eval(
+            "'printk.c'::log_buf")).split()[0], 16)
+        log_first_idx = int(gdb.parse_and_eval("'printk.c'::log_first_idx"))
+        log_next_idx = int(gdb.parse_and_eval("'printk.c'::log_next_idx"))
+        log_buf_len = int(gdb.parse_and_eval("'printk.c'::log_buf_len"))
 
         inf = gdb.inferiors()[0]
         start = log_buf_addr + log_first_idx
_
