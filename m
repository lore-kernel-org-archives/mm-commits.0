From: akpm@linux-foundation.org
Subject: [merged]
 scripts-tags-change-find_other_sources-for-include-folders.patch removed
 from -mm tree
Date: Thu, 01 Feb 2018 11:28:56 -0800
Message-ID: <20180201192856.FMHtXYWk7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56472 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754682AbeBAT26 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:28:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arend.vanspriel@broadcom.com, mm-commits@vger.kernel.org, robert.jarzmik@free.fr


The patch titled
     Subject: scripts/tags.sh: change find_other_sources() for include directories
has been removed from the -mm tree.  Its filename was
     scripts-tags-change-find_other_sources-for-include-folders.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


