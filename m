From: akpm@linux-foundation.org
Subject: + v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:37:57 -0700
Message-ID: <200807292237.m6TMbvxs025517@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYG2WiJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:38:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     v4l: fix kernel-doc warning, function name, and docbook filename
has been added to the -mm tree.  Its filename is
     v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: v4l: fix kernel-doc warning, function name, and docbook filename
From: Randy Dunlap <randy.dunlap@oracle.com>

Change function name in kernel-doc and add kernel-doc for parameter @index:
Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'

Also change source file name in DocBook/videobook.tmpl to match the new
source file name.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/videobook.tmpl |    2 +-
 drivers/media/video/v4l2-dev.c       |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN Documentation/DocBook/videobook.tmpl~v4l-fix-kernel-doc-warning-function-name-and-docbook-filename Documentation/DocBook/videobook.tmpl
--- a/Documentation/DocBook/videobook.tmpl~v4l-fix-kernel-doc-warning-function-name-and-docbook-filename
+++ a/Documentation/DocBook/videobook.tmpl
@@ -1648,7 +1648,7 @@ static struct video_buffer capture_fb;
 
   <chapter id="pubfunctions">
      <title>Public Functions Provided</title>
-!Edrivers/media/video/videodev.c
+!Edrivers/media/video/v4l2-dev.c
   </chapter>
 
 </book>
diff -puN drivers/media/video/v4l2-dev.c~v4l-fix-kernel-doc-warning-function-name-and-docbook-filename drivers/media/video/v4l2-dev.c
--- a/drivers/media/video/v4l2-dev.c~v4l-fix-kernel-doc-warning-function-name-and-docbook-filename
+++ a/drivers/media/video/v4l2-dev.c
@@ -222,11 +222,13 @@ int video_register_device(struct video_d
 EXPORT_SYMBOL(video_register_device);
 
 /**
- *	video_register_device - register video4linux devices
+ *	video_register_device_index - register video4linux devices
  *	@vfd:  video device structure we want to register
  *	@type: type of device to register
  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
  *             -1 == first free)
+ *	@index: stream number based on parent device;
+ *		-1 if auto assign, requested number otherwise
  *
  *	The registration code assigns minor numbers based on the type
  *	requested. -ENFILE is returned in all the device slots for this
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
v4l-fix-kernel-doc-warning-function-name-and-docbook-filename.patch
documentation-build-source-files-in-documentation-sub-dir.patch
genksyms-parser-fix-the-__attribute__-rule.patch
genksyms-include-extern-information-in-dumps.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
netfilter-conntrack_helper-needs-to-include-rculisth.patch
lkdtm-fix-for-config_scsi=n.patch
git-unionfs.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works.patch
rcu-fix-synchronize_rcu-so-that-kernel-doc-works-comment.patch
profile-likely-unlikely-macros.patch

