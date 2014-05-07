From: akpm@linux-foundation.org
Subject: [merged] agp-info-leak-in-agpioc_info_wrap.patch removed from -mm tree
Date: Wed, 07 May 2014 12:05:21 -0700
Message-ID: <536a83f1.lVb/tZv3PKBf6AZI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaEGTFW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2014 15:05:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daniel.vetter@ffwll.ch, airlied@linux.ie, dan.carpenter@oracle.com

Subject: [merged] agp-info-leak-in-agpioc_info_wrap.patch removed from -mm tree
To: dan.carpenter@oracle.com,airlied@linux.ie,daniel.vetter@ffwll.ch,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 07 May 2014 12:05:21 -0700


The patch titled
     Subject: agp: info leak in agpioc_info_wrap()
has been removed from the -mm tree.  Its filename was
     agp-info-leak-in-agpioc_info_wrap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: agp: info leak in agpioc_info_wrap()

On 64 bit systems the agp_info struct has a 4 byte hole between ->agp_mode
and ->aper_base.  We need to clear it to avoid disclosing stack
information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/agp/frontend.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/char/agp/frontend.c~agp-info-leak-in-agpioc_info_wrap drivers/char/agp/frontend.c
--- a/drivers/char/agp/frontend.c~agp-info-leak-in-agpioc_info_wrap
+++ a/drivers/char/agp/frontend.c
@@ -730,6 +730,7 @@ static int agpioc_info_wrap(struct agp_f
 
 	agp_copy_info(agp_bridge, &kerninfo);
 
+	memset(&userinfo, 0, sizeof(userinfo));
 	userinfo.version.major = kerninfo.version.major;
 	userinfo.version.minor = kerninfo.version.minor;
 	userinfo.bridge_id = kerninfo.device->vendor |
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

origin.patch
lib-stringc-use-the-name-c-string-in-comments.patch
linux-next.patch

