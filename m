From: akpm@linux-foundation.org
Subject: + printk-fix-%pb-when-theres-no-symbol-at-the-address.patch added to -mm tree
Date: Mon, 14 Jul 2014 12:49:53 -0700
Message-ID: <53c43461.q6eQbPj7etFo+r+x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60164 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579AbaGNTty (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 15:49:54 -0400
Received: by mail-vc0-f202.google.com with SMTP id id10so799176vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 12:49:53 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@kernel.org, fweisbec@gmail.com, jpoimboe@redhat.com, masami.hiramatsu.pt@hitachi.com, rostedt@goodmis.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/kallsyms.c: fix %pB when there's no symbol at the address
has been added to the -mm tree.  Its filename is
     printk-fix-%pb-when-theres-no-symbol-at-the-address.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/printk-fix-%pb-when-theres-no-symbol-at-the-address.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-%pb-when-theres-no-symbol-at-the-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

printk-fix-%pb-when-theres-no-symbol-at-the-address.patch
linux-next.patch

