From: akpm@linux-foundation.org
Subject: + documentation-fix-docbooks=-building.patch added to -mm tree
Date: Tue, 20 May 2014 13:46:54 -0700
Message-ID: <537bbf3e.YQ308kN/dWEY5AVK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbaETUqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 16:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rdunlap@xenotime.net, mchehab@redhat.com, johannes.berg@intel.com

Subject: + documentation-fix-docbooks=-building.patch added to -mm tree
To: johannes.berg@intel.com,mchehab@redhat.com,rdunlap@xenotime.net
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 13:46:54 -0700


The patch titled
     Subject: Documentation: fix DOCBOOKS=... building
has been added to the -mm tree.  Its filename is
     documentation-fix-docbooks=-building.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-fix-docbooks=-building.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-fix-docbooks=-building.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Berg <johannes.berg@intel.com>
Subject: Documentation: fix DOCBOOKS=... building

Prior to
commit 4266129964b8238526936d723de65b419d8069c6
Author: Mauro Carvalho Chehab <mchehab@redhat.com>
Date:   Tue May 31 16:27:44 2011 -0300

    [media] DocBook: Move all media docbook stuff into its own directory

it was possible to build only a single (or more) book(s) by calling, for
example

	make htmldocs DOCBOOKS=80211.xml

This now fails:
cp: target `.../Documentation/DocBook//media_api' is not a directory

Ignore errors from that copy to make this possible again.

Fixes: 4266129964b8 ("[media] DocBook: Move all media docbook stuff into its own directory")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/media/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/DocBook/media/Makefile~documentation-fix-docbooks=-building Documentation/DocBook/media/Makefile
--- a/Documentation/DocBook/media/Makefile~documentation-fix-docbooks=-building
+++ a/Documentation/DocBook/media/Makefile
@@ -195,7 +195,7 @@ DVB_DOCUMENTED = \
 #
 
 install_media_images = \
-	$(Q)cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
+	$(Q)-cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
 
 $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
 	$(Q)base64 -d $< >$@
_

Patches currently in -mm which might be from johannes.berg@intel.com are

documentation-fix-docbooks=-building.patch
compilerh-avoid-sparse-errors-in-__compiletime_error_fallback.patch
linux-next.patch

