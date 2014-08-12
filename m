From: akpm@linux-foundation.org
Subject: [merged]
 printk-fix-%pb-when-theres-no-symbol-at-the-address.patch removed from -mm
 tree
Date: Tue, 12 Aug 2014 12:38:14 -0700
Message-ID: <53ea6d26.+mOC6SL/fvlGnzp7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:45947 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaHLTiP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:15 -0400
Received: by mail-ob0-f201.google.com with SMTP id nu7so1919748obb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:14 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@kernel.org, fweisbec@gmail.com, jpoimboe@redhat.com, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyms.c: fix %pB when there's no symbol at the address
has been removed from the -mm tree.  Its filename was
     printk-fix-%pb-when-theres-no-symbol-at-the-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Namhyung Kim <namhyung@kernel.org>
Subject: kernel/kallsyms.c: fix %pB when there's no symbol at the address

__sprint_symbol() should restore original address when kallsyms_lookup()
failed to find a symbol.  It's reported when dumpstack shows an address in
a dynamically allocated trampoline for ftrace.

  [ 1314.612287]  [<ffffffff81700312>] dump_stack+0x45/0x56
  [ 1314.612290]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
  [ 1314.612293]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
  [ 1314.612306]  [<ffffffffa00160c4>] 0xffffffffa00160c3

You can see a difference in the hex address - c4 and c3.  Fix it.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reported-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kallsyms.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kallsyms.c~printk-fix-%pb-when-theres-no-symbol-at-the-address kernel/kallsyms.c
--- a/kernel/kallsyms.c~printk-fix-%pb-when-theres-no-symbol-at-the-address
+++ a/kernel/kallsyms.c
@@ -364,7 +364,7 @@ static int __sprint_symbol(char *buffer,
 	address += symbol_offset;
 	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
 	if (!name)
-		return sprintf(buffer, "0x%lx", address);
+		return sprintf(buffer, "0x%lx", address - symbol_offset);
 
 	if (name != buffer)
 		strcpy(buffer, name);
_

Patches currently in -mm which might be from namhyung@kernel.org are

origin.patch

