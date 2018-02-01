From: akpm@linux-foundation.org
Subject: [patch 004/119] scripts/tags.sh: change
 find_other_sources() for include directories
Date: Wed, 31 Jan 2018 16:14:14 -0800
Message-ID: <20180201001414.8bXbX66iX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33500 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754248AbeBAAOP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:14:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arend.vanspriel@broadcom.com, mm-commits@vger.kernel.org, robert.jarzmik@free.fr, torvalds@linux-foundation.org

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
