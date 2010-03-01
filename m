From: akpm@linux-foundation.org
Subject: + um-tell-git-to-ignore-generated-files.patch added to -mm tree
Date: Mon, 01 Mar 2010 15:22:59 -0800
Message-ID: <201003012322.o21NMxIX005861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37739 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab0CAXYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 18:24:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, jdike@addtoit.com, viro@zeniv.linux.org.uk


The patch titled
     um: tell git to ignore generated files
has been added to the -mm tree.  Its filename is
     um-tell-git-to-ignore-generated-files.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: um: tell git to ignore generated files
From: WANG Cong <xiyou.wangcong@gmail.com>

Tell git to ignore the generated files under um, except:

 include/shared/kern_constants.h
 include/shared/user_constants.h

which will be moved to include/generated.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .gitignore         |    1 +
 arch/um/.gitignore |    3 +++
 2 files changed, 4 insertions(+)

diff -puN .gitignore~um-tell-git-to-ignore-generated-files .gitignore
--- a/.gitignore~um-tell-git-to-ignore-generated-files
+++ a/.gitignore
@@ -36,6 +36,7 @@ modules.builtin
 #
 tags
 TAGS
+linux
 vmlinux
 vmlinuz
 System.map
diff -puN /dev/null arch/um/.gitignore
--- /dev/null
+++ a/arch/um/.gitignore
@@ -0,0 +1,3 @@
+kernel/config.c
+kernel/config.tmp
+kernel/vmlinux.lds
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

origin.patch
linux-next.patch
mm-remove-function-free_hot_page.patch
mm-remove-function-free_hot_page-fix.patch
um-tell-git-to-ignore-generated-files.patch
prctl-add-pr_set_proctitle_area-option-for-prctl.patch
lkdtm-add-debugfs-access-and-loosen-kprobe-ties.patch
exec-create-initial-stack-independent-of-page_size.patch
coredump-set-group_exit_code-for-other-clone_vm-tasks-too.patch
rtc-mxc-fix-memory-leak.patch
rtc-mxc-fix-memory-leak-fix.patch

