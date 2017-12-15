From: akpm@linux-foundation.org
Subject: +
 scripts-tags-change-find_other_sources-for-include-folders.patch added to
 -mm tree
Date: Fri, 15 Dec 2017 14:25:12 -0800
Message-ID: <5a344bc8.8Efge/fuVlThMtE5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58350 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932864AbdLOWZN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 17:25:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arend.vanspriel@broadcom.com, robert.jarzmik@free.fr, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/tags.sh: change find_other_sources() for include directories
has been added to the -mm tree.  Its filename is
     scripts-tags-change-find_other_sources-for-include-folders.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-tags-change-find_other_sources-for-include-folders.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-tags-change-find_other_sources-for-include-folders.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: scripts/tags.sh: change find_other_sources() for include directories

The current find done in find_other_sources() excludes directories in the
kernel tree that are named 'include', eg.:

	./security/apparmor/include
	./security/selinux/include
	./drivers/net/wireless/broadcom/brcm80211/include
	./drivers/gpu/drm/amd/acp/include
	./drivers/gpu/drm/amd/display/include
	./drivers/gpu/drm/amd/include
	./drivers/gpu/drm/nouveau/include

This changes the find command in find_other_sources() to include those
using the -path option.

Link: http://lkml.kernel.org/r/1513335768-7852-1-git-send-email-arend.vanspriel@broadcom.com
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/tags.sh~scripts-tags-change-find_other_sources-for-include-folders scripts/tags.sh
--- a/scripts/tags.sh~scripts-tags-change-find_other_sources-for-include-folders
+++ a/scripts/tags.sh
@@ -77,7 +77,7 @@ find_include_sources()
 find_other_sources()
 {
 	find ${tree}* $ignore \
-	     \( -name include -o -name arch -o -name '.tmp_*' \) -prune -o \
+	     \( -path ${tree}include -o -path ${tree}arch -o -name '.tmp_*' \) -prune -o \
 	       -name "$1" -not -type l -print;
 }
 
_

Patches currently in -mm which might be from arend.vanspriel@broadcom.com are

scripts-tags-change-find_other_sources-for-include-folders.patch

