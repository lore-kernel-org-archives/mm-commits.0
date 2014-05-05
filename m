From: akpm@linux-foundation.org
Subject: + agp-info-leak-in-agpioc_info_wrap.patch added to -mm tree
Date: Mon, 05 May 2014 14:01:38 -0700
Message-ID: <5367fc32.0Dw/3IV9uWcHgabQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51042 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbaEEVBj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2014 17:01:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daniel.vetter@ffwll.ch, airlied@linux.ie, dan.carpenter@oracle.com

Subject: + agp-info-leak-in-agpioc_info_wrap.patch added to -mm tree
To: dan.carpenter@oracle.com,airlied@linux.ie,daniel.vetter@ffwll.ch
From: akpm@linux-foundation.org
Date: Mon, 05 May 2014 14:01:38 -0700


The patch titled
     Subject: agp: info leak in agpioc_info_wrap()
has been added to the -mm tree.  Its filename is
     agp-info-leak-in-agpioc_info_wrap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/agp-info-leak-in-agpioc_info_wrap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/agp-info-leak-in-agpioc_info_wrap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

agp-info-leak-in-agpioc_info_wrap.patch
lib-stringc-use-the-name-c-string-in-comments.patch
linux-next.patch

