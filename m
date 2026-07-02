Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFC81B85F8
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782953508; cv=none; b=XubivVgGCc9Nw4Lib7i/MWaeK+f9GZyVF5Y3YXp4Tt6zZufeKAS+kNhFwTCRTjvZwlNqBu6h7NYMmbLPEflUudqy4CQOEFgbLJLSOeTZPrtxJ0UvconNT72FegGIP3hlk0PWyZZpdL4awlRCWCuNeYLDVSpx42Fwca0OWGQsvII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782953508; c=relaxed/simple;
	bh=rQoAiT6GhtkoCu+BV6bk5EZgQOUm8E4vqmmlPkFs+ds=;
	h=Date:To:From:Subject:Message-Id; b=dNX75TnsKg2xhGW40cJBUCe8HMRwnb5p974WZlnneJDaLy3tHQ3UIkii82XyByDirZbL5X0LCMiYq2QLFy/YKiTBamZ+Id6FYEAXa82nFNSFEU16geJyJtPcEgRhL4wYyC5jEq5EnlwZsju/+YHmJKa9z4YqrPYVGkEYTf8MPi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AQfAj7hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AQfAj7hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8FE1F000E9;
	Thu,  2 Jul 2026 00:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782953506;
	bh=zuxjUw9engSR0R/FK81DB0CKuf20Via5y2Wx5BCM8F0=;
	h=Date:To:From:Subject;
	b=AQfAj7hkh3GqlLHuUOlyBdEKCUgAQx1FelWje42tuF+sxk8OluV7JO1xwP8hY7aQL
	 J1BBgoNLRn7ft0nmIO8gi+01Z+SK9sMZUhxWkDS/fOazW/M1407mRhlnf9LdGpFmkh
	 UiN0olLyvncApgSXUBkGivxpchH+kFKJWw4g+KxM=
Date: Wed, 01 Jul 2026 17:51:46 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,hirofumi@mail.parknet.co.jp,david.laight.linux@gmail.com,brauner@kernel.org,adinata.softwareengineer@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-avoid-stack-overflow-warning.patch added to mm-hotfixes-unstable branch
Message-Id: <20260702005146.8F8FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: avoid stack overflow warning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fat-avoid-stack-overflow-warning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-avoid-stack-overflow-warning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: fat: avoid stack overflow warning
Date: Fri, 15 May 2026 22:44:46 +0200

Building the fat kunit tests on with -fsanitize=alignment reveals some
rather excessive stack usage:

fs/fat/fat_test.c: In function 'fat_clus_to_blknr_test':
fs/fat/fat_test.c:33:1: error: the frame size of 4736 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]
   33 | }
      | ^
fs/fat/fat_test.c: In function 'fat_get_blknr_offset_test':
fs/fat/fat_test.c:52:1: error: the frame size of 4800 bytes is larger than 1536 bytes [-Werror=frame-larger-than=]

The problem is clearly related to the on-stack copy of a local
msdos_sb_info structure.  Avoid this by making that copy 'static const'
and changing the called functions to accept a constant input.

Link: https://lore.kernel.org/20260515204456.2692208-1-arnd@kernel.org
Fixes: 410002f8139c ("kunit: fat: test cluster and directory i_pos layout helpers")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Adi Nata <adinata.softwareengineer@gmail.com>
Cc: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat.h      |    4 ++--
 fs/fat/fat_test.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/fs/fat/fat.h~fat-avoid-stack-overflow-warning
+++ a/fs/fat/fat.h
@@ -249,13 +249,13 @@ static inline unsigned char fat_checksum
 	return s;
 }
 
-static inline sector_t fat_clus_to_blknr(struct msdos_sb_info *sbi, int clus)
+static inline sector_t fat_clus_to_blknr(const struct msdos_sb_info *sbi, int clus)
 {
 	return ((sector_t)clus - FAT_START_ENT) * sbi->sec_per_clus
 		+ sbi->data_start;
 }
 
-static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
+static inline void fat_get_blknr_offset(const struct msdos_sb_info *sbi,
 				loff_t i_pos, sector_t *blknr, int *offset)
 {
 	*blknr = i_pos >> sbi->dir_per_block_bits;
--- a/fs/fat/fat_test.c~fat-avoid-stack-overflow-warning
+++ a/fs/fat/fat_test.c
@@ -22,7 +22,7 @@ static void fat_checksum_test(struct kun
 
 static void fat_clus_to_blknr_test(struct kunit *test)
 {
-	struct msdos_sb_info sbi = {
+	static const struct msdos_sb_info sbi = {
 		.sec_per_clus = 4,
 		.data_start = 100,
 	};
@@ -34,7 +34,7 @@ static void fat_clus_to_blknr_test(struc
 
 static void fat_get_blknr_offset_test(struct kunit *test)
 {
-	struct msdos_sb_info sbi = {
+	static const struct msdos_sb_info sbi = {
 		.dir_per_block = 16,
 		.dir_per_block_bits = 4,
 	};
_

Patches currently in -mm which might be from arnd@arndb.de are

fat-avoid-stack-overflow-warning.patch
mm-damon-core-reduce-kernel-stack-usage.patch

