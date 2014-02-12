From: akpm@linux-foundation.org
Subject: + kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch
 added to -mm tree
Date: Wed, 12 Feb 2014 13:32:42 -0800
Message-ID: <52fbe87a.Xv014ABKpD++qhxc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52879 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaBLVcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Feb 2014 16:32:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, xemul@parallels.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au, oleg@redhat.com, mtk.manpages@gmail.com, keescook@chromium.org, holt@sgi.com, gang.chen@asianux.com, ebiederm@xmission.com, adityakali@google.com, avagin@openvz.org

Subject: + kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch added to -mm tree
To: avagin@openvz.org,adityakali@google.com,ebiederm@xmission.com,gang.chen@asianux.com,holt@sgi.com,keescook@chromium.org,mtk.manpages@gmail.com,oleg@redhat.com,sfr@canb.auug.org.au,viro@zeniv.linux.org.uk,xemul@parallels.com
From: akpm@linux-foundation.org
Date: Wed, 12 Feb 2014 13:32:42 -0800


The patch titled
     Subject: kernel/sys.c: reduce required permission for prctl_set_mm
has been added to the -mm tree.  Its filename is
     kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Vagin <avagin@openvz.org>
Subject: kernel/sys.c: reduce required permission for prctl_set_mm

Currently prctl_set_mm requires the global CAP_SYS_RESOURCE, this patch
reduce requiremence to CAP_SYS_RESOURCE in the current namespace.

When we restore a task we need to set up text, data and data heap sizes
from userspace to the values a task had at checkpoint time.

Currently we can not restore these parameters, if a task lives in a
non-root user name space, because it has no capabilities in the parent
namespace.

prctl_set_mm() changes parameters of the current task and doesn't affect
other tasks.

This patch affects the RLIMIT_DATA limit, because a consumtiuon is
calculated relatively to mm->end_data, mm->start_data, mm->start_brk.

rlim = rlimit(RLIMIT_DATA);
if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
		(mm->end_data - mm->start_data) > rlim)
	goto out;

This limit affects calls to brk() and sbrk(), but it doesn't affect
mmap. So I think requirement of CAP_SYS_RESOURCE in the current
namespace is enough for this limit.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Chen Gang <gang.chen@asianux.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Aditya Kali <adityakali@google.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/sys.c~kernel-sysc-reduce-required-permission-for-prctl_set_mm kernel/sys.c
--- a/kernel/sys.c~kernel-sysc-reduce-required-permission-for-prctl_set_mm
+++ a/kernel/sys.c
@@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_RESOURCE))
+	if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
 		return -EPERM;
 
 	if (opt == PR_SET_MM_EXE_FILE)
_

Patches currently in -mm which might be from avagin@openvz.org are

origin.patch
kernel-sysc-reduce-required-permission-for-prctl_set_mm.patch

