From: akpm@linux-foundation.org
Subject: + mm-use-%pk-for-proc-vmallocinfo.patch added to -mm tree
Date: Wed, 03 Oct 2012 13:39:18 -0700
Message-ID: <20121003203918.ACE261E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:62873 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816Ab2JCUjT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Oct 2012 16:39:19 -0400
Received: by ghbz15 with SMTP id z15so981934ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 03 Oct 2012 13:39:19 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: keescook@chromium.org, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com, spender@grsecurity.net


The patch titled
     Subject: mm: use %pK for /proc/vmallocinfo
has been added to the -mm tree.  Its filename is
     mm-use-%pk-for-proc-vmallocinfo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm: use %pK for /proc/vmallocinfo

In the paranoid case of sysctl kernel.kptr_restrict=2, mask the kernel
virtual addresses in /proc/vmallocinfo too.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Brad Spengler <spender@grsecurity.net>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmalloc.c~mm-use-%pk-for-proc-vmallocinfo mm/vmalloc.c
--- a/mm/vmalloc.c~mm-use-%pk-for-proc-vmallocinfo
+++ a/mm/vmalloc.c
@@ -2571,7 +2571,7 @@ static int s_show(struct seq_file *m, vo
 {
 	struct vm_struct *v = p;
 
-	seq_printf(m, "0x%p-0x%p %7ld",
+	seq_printf(m, "0x%pK-0x%pK %7ld",
 		v->addr, v->addr + v->size, v->size);
 
 	if (v->caller)
_

Patches currently in -mm which might be from keescook@chromium.org are

origin.patch
linux-next.patch
audith-replace-defines-with-c-stubs.patch
audith-replace-defines-with-c-stubs-fix.patch
mm-use-%pk-for-proc-vmallocinfo.patch
poweroff-fix-bug-in-orderly_poweroff.patch
checkpatch-fix-name-of-module_parm_desc.patch
coredump-make-core-dump-functionality-optional.patch
coredump-make-core-dump-functionality-optional-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-update-coredump-related-headers.patch

