From: akpm@linux-foundation.org
Subject: + documentation-sparsetxt-document-context-annotations-for-lock-checking.patch added to -mm tree
Date: Thu, 18 Oct 2012 12:38:24 -0700
Message-ID: <20121018193825.135945C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:37782 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2JRTi1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Oct 2012 15:38:27 -0400
Received: by mail-lb0-f202.google.com with SMTP id l12so553408lbo.1
        for <mm-commits@vger.kernel.org>; Thu, 18 Oct 2012 12:38:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ecashin@coraid.com


The patch titled
     Subject: Documentation/sparse.txt: document context annotations for lock checking
has been added to the -mm tree.  Its filename is
     documentation-sparsetxt-document-context-annotations-for-lock-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ed Cashin <ecashin@coraid.com>
Subject: Documentation/sparse.txt: document context annotations for lock checking

The context feature of sparse is used with the Linux kernel sources to
check for imbalanced uses of locks.  Document the annotations defined in
include/linux/compiler.h that tell sparse what to expect when a lock is
held on function entry, exit, or both.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sparse.txt |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff -puN Documentation/sparse.txt~documentation-sparsetxt-document-context-annotations-for-lock-checking Documentation/sparse.txt
--- a/Documentation/sparse.txt~documentation-sparsetxt-document-context-annotations-for-lock-checking
+++ a/Documentation/sparse.txt
@@ -49,6 +49,24 @@ be generated without __CHECK_ENDIAN__.
 __bitwise - noisy stuff; in particular, __le*/__be* are that.  We really
 don't want to drown in noise unless we'd explicitly asked for it.
 
+Using sparse for lock checking
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+
+The following macros are undefined for gcc and defined during a sparse
+run to use the "context" tracking feature of sparse, applied to
+locking.  These annotations tell sparse when a lock is held, with
+regard to the annotated function's entry and exit.
+
+__must_hold - The specified lock is held on function entry and exit.
+
+__acquires - The specified lock is held on function exit, but not entry.
+
+__releases - The specified lock is held on function entry, but not exit.
+
+If the function enters and exits without the lock held, acquiring and
+releasing the lock inside the function in a balanced way, no
+annotation is needed.  The tree annotations above are for cases where
+sparse would otherwise report a context imbalance.
 
 Getting sparse
 ~~~~~~~~~~~~~~
_

Patches currently in -mm which might be from ecashin@coraid.com are

linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch
documentation-sparsetxt-document-context-annotations-for-lock-checking.patch
aoe-describe-the-behavior-of-the-err-character-device.patch
aoe-print-warning-regarding-a-common-reason-for-dropped-transmits.patch
aoe-update-cap-on-outstanding-commands-based-on-config-query-response.patch
aoe-support-the-forgetting-flushing-of-a-user-specified-aoe-target.patch
aoe-support-larger-i-o-requests-via-aoe_maxsectors-module-param.patch
aoe-payload-sysfs-file-exports-per-aoe-command-data-transfer-size.patch
aoe-cleanup-remove-unused-ata_scnt-function.patch
aoe-whitespace-cleanup.patch
aoe-update-driver-internal-version-number-to-60.patch

