Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480481E486
	for <mm-commits@vger.kernel.org>; Thu, 18 Jan 2024 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705616183; cv=none; b=ZPRZMQK5P4pkvOPUYD2yKc73uOAGIFBNPxGAw8nU89vWQ2fpUCb5z7cKsy1VQsx55FW8o5e3Rel13gmrgVrjuE8lSVUY1/rbPNCP0Pldpr+iIA3rwm8K4TwsMuAdsbu6Cb0/Yw4Dut7zDI+xNGuQ+q9jrC9QLGZuQ+t7i+O2/S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705616183; c=relaxed/simple;
	bh=89rCDzKbZi8pl0I1qe1zIRBWdxC8Yx5qEm5uyp9GOpg=;
	h=Date:To:From:Subject:Message-Id; b=naMikHKw+CohJvWWpKg6XSwUqlav+/9VyJQCNM3uhkRdXPIC0YU9fhvoDN0DCBH+41UH2IVu2OXT0A/TQxnJ1IyTe+3WCKOLWrKmBwmCFdAQjnD8i9e8nSMwlr9cEDRSutDe6LbaHv4xwnP1PzwblPGC12Ys0nE/HkI+J2RoTlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HpUKswxR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HpUKswxR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E8BC433F1;
	Thu, 18 Jan 2024 22:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705616182;
	bh=89rCDzKbZi8pl0I1qe1zIRBWdxC8Yx5qEm5uyp9GOpg=;
	h=Date:To:From:Subject:From;
	b=HpUKswxREv9Zc1OIEPHUuK8axxUecX0K2rvPLUegOzmlVzQt2aXTj2UbtJMjtdG+W
	 J+bx1U+BWo5ua2R52pPB9eDnpN5DPFFrCnq2VU/WQSaz5o0PPFLh1Dn0YQpwc3GYm0
	 NnJiX+9XhgnvCC0qTwSek7JqXLE+jYqac0pCtolc=
Date: Thu, 18 Jan 2024 14:16:20 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,yosryahmed@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-supplement-of-zswap-maintainers-update.patch added to mm-hotfixes-unstable branch
Message-Id: <20240118221622.63E8BC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: supplement of zswap maintainers update
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     maintainers-supplement-of-zswap-maintainers-update.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-supplement-of-zswap-maintainers-update.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yosry Ahmed <yosryahmed@google.com>
Subject: MAINTAINERS: supplement of zswap maintainers update
Date: Wed, 17 Jan 2024 18:21:52 +0000

As discussed on the mailing list [1], merge the zpool maintainers entry
into the zswap one.  Also, add CREDITS entries for previous zswap/zpool
maintainers.

[1] https://lore.kernel.org/linux-mm/CAJD7tkYx4YWhGoVwnSeGc8dY_1aRRxxg8PzWBV==A6iqG_OgFw@mail.gmail.com/

Link: https://lkml.kernel.org/r/20240117182152.1439822-1-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Dan Streetman <ddstreet@ieee.org>
Acked-by: Seth Jennings <sjenning@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 CREDITS     |   13 +++++++++++++
 MAINTAINERS |    9 ++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

--- a/CREDITS~maintainers-supplement-of-zswap-maintainers-update
+++ a/CREDITS
@@ -2148,6 +2148,19 @@ N: Mike Kravetz
 E: mike.kravetz@oracle.com
 D: Maintenance and development of the hugetlb subsystem
 
+N: Seth Jennings
+E: sjenning@redhat.com
+D: Creation and maintenance of zswap
+
+N: Dan Streetman
+E: ddstreet@ieee.org
+D: Maintenance and development of zswap
+D: Creation and maintenance of the zpool API
+
+N: Vitaly Wool
+E: vitaly.wool@konsulko.com
+D: Maintenance and development of zswap
+
 N: Andreas S. Krebs
 E: akrebs@altavista.net
 D: CYPRESS CY82C693 chipset IDE, Digital's PC-Alpha 164SX boards
--- a/MAINTAINERS~maintainers-supplement-of-zswap-maintainers-update
+++ a/MAINTAINERS
@@ -24226,13 +24226,6 @@ T:	git git://git.kernel.org/pub/scm/linu
 F:	Documentation/filesystems/zonefs.rst
 F:	fs/zonefs/
 
-ZPOOL COMPRESSED PAGE STORAGE API
-M:	Dan Streetman <ddstreet@ieee.org>
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	include/linux/zpool.h
-F:	mm/zpool.c
-
 ZR36067 VIDEO FOR LINUX DRIVER
 M:	Corentin Labbe <clabbe@baylibre.com>
 L:	mjpeg-users@lists.sourceforge.net
@@ -24284,7 +24277,9 @@ M:	Nhat Pham <nphamcs@gmail.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/zswap.rst
+F:	include/linux/zpool.h
 F:	include/linux/zswap.h
+F:	mm/zpool.c
 F:	mm/zswap.c
 
 THE REST
_

Patches currently in -mm which might be from yosryahmed@google.com are

maintainers-supplement-of-zswap-maintainers-update.patch

