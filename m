Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A04842AEF5
	for <mm-commits@vger.kernel.org>; Thu,  9 Jul 2026 22:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783637399; cv=none; b=QliqX+zs3BgjX2PgRjHkhqTUjfrgUzd4dwN17mIPXimCTp6zPfmQ8Hqg3X2rqYsCzaQ5rNyBGfhPNrf9ej0aOEF88FsuiZDR6B+8C0EfvwOH5nTcta0rYThGePKwIL0ww73Pf8REWlGamaS6J5HiqpN1/dRvND5/kYAMwqFvdzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783637399; c=relaxed/simple;
	bh=DzS1Ro1fpNui/zvMiEPfukuijMCT4FuU7hGphcmiPAI=;
	h=Date:To:From:Subject:Message-Id; b=iP8A3NJfMdfSuIofLLTtZpK78Tx1Pj0uzlWlAxchjIAIQFkgDB3RsrH0QPFsk5v1WM5Cp44UT5cIX9H2jd4LW/u/9jEB72LhJrnOhDIOmWLctD7pw1lPpQK4cgvGl+HcJA6nCg5IBql9xIfaQCVrOv/ynys6K2dds7ThT6CO7WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qQcAHycg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qQcAHycg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EE81F00A3A;
	Thu,  9 Jul 2026 22:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783637398;
	bh=h3pqM26hXzc/xYr80rS36MoRGVV9IwogiRFLNUiJ6gY=;
	h=Date:To:From:Subject;
	b=qQcAHycgbvJs/jsnDsst1vs+Fez0mx8LMq1tj0PV6RISwcQKJgKcVSbbHIOnkZiU6
	 GAt7zuL63TSrQuT0XZSXk0xC0UtRvu3QMh7iWf2CeRsxQ8f2m9pKUDbvyl2jWncQWK
	 KOtN9/kwUFpkPNjO78G4VU7gDaIbNBBubo7ELkVo=
Date: Thu, 09 Jul 2026 15:49:57 -0700
To: mm-commits@vger.kernel.org,jack@suse.cz,hirofumi@mail.parknet.co.jp,david.laight.linux@gmail.com,brauner@kernel.org,adinata.softwareengineer@gmail.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fat-avoid-stack-overflow-warning.patch removed from -mm tree
Message-Id: <20260709224958.36EE81F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fat: avoid stack overflow warning
has been removed from the -mm tree.  Its filename was
     fat-avoid-stack-overflow-warning.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-damon-core-reduce-kernel-stack-usage.patch

