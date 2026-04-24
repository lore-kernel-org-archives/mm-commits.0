Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E5636D9F6
	for <mm-commits@vger.kernel.org>; Fri, 24 Apr 2026 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777034359; cv=none; b=LQVgLp8pkwcFIy/n7qvdSorlJEUYEGneUp9Mt8UOZ8Mzwju3Dv8xa0pOXRSP91hJ5aYBFaUEqIPF459Ql9qnGiG8sk6OLUUTk+WNX2LtaGzpQhZjY83l7NFHrCChjbLyPU8VHiJv06WprqQ5Axm7zhGDOV3Ygw3E5x8SHytbyt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777034359; c=relaxed/simple;
	bh=+aabE8L5Z1bJf/FMOQ6W9jONj3uH8HpTKE6y8a70Ye0=;
	h=Date:To:From:Subject:Message-Id; b=LrOrXQJpM70L0UHBT6QVFak1bxrnY2YAYG0fko23CqDJOc2wpSUa9/Zeg72AmE5YnbCCQ2J5y/M95aQx3hgn81T8Q0eaUeLOMv26Mjc6EIqmn7tZsZkm5TdWLkXiBRxGYnatO5NH0OQHh6QbkCQaNZ+EoTa2bmHgAZJh3FRoVPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yFnic3K1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yFnic3K1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18B5C19425;
	Fri, 24 Apr 2026 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777034359;
	bh=+aabE8L5Z1bJf/FMOQ6W9jONj3uH8HpTKE6y8a70Ye0=;
	h=Date:To:From:Subject:From;
	b=yFnic3K1U/VVztNqLwZz+ZB5EJvdDpuO2fRGMbVns0QhHdtjOCO9L6OjwPjF6YlUL
	 lrEIbLqdf7i+eSAlCxgQvl6wGQUR7FS7vRhlJh7NPqJf0l0DPwhTZF3QJhwvzdlny6
	 tHhQZptPUFgCheD4SF+g+4nxl52xZB68lVqczIjQ=
Date: Fri, 24 Apr 2026 05:39:18 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,adinata.softwareengineer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch added to mm-nonmm-unstable branch
Message-Id: <20260424123918.E18B5C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kunit: fat: test cluster and directory i_pos layout helpers
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Adi Nata <adinata.softwareengineer@gmail.com>
Subject: kunit: fat: test cluster and directory i_pos layout helpers
Date: Sun, 5 Apr 2026 09:19:20 +0800

Add KUnit coverage for fat_clus_to_blknr() and fat_get_blknr_offset()
using stub msdos_sb_info values so cluster-to-sector and i_pos split math
stays correct.

Link: https://lore.kernel.org/20260405011920.28622-1-adinata.softwareengineer@gmail.com
Signed-off-by: Adi Nata <adinata.softwareengineer@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/fat_test.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

--- a/fs/fat/fat_test.c~kunit-fat-test-cluster-and-directory-i_pos-layout-helpers
+++ a/fs/fat/fat_test.c
@@ -20,6 +20,37 @@ static void fat_checksum_test(struct kun
 	KUNIT_EXPECT_EQ(test, fat_checksum("ABCDEFGHA  "), (u8)98);
 }
 
+static void fat_clus_to_blknr_test(struct kunit *test)
+{
+	struct msdos_sb_info sbi = {
+		.sec_per_clus = 4,
+		.data_start = 100,
+	};
+
+	KUNIT_EXPECT_EQ(test, (sector_t)100,
+			fat_clus_to_blknr(&sbi, FAT_START_ENT));
+	KUNIT_EXPECT_EQ(test, (sector_t)112, fat_clus_to_blknr(&sbi, 5));
+}
+
+static void fat_get_blknr_offset_test(struct kunit *test)
+{
+	struct msdos_sb_info sbi = {
+		.dir_per_block = 16,
+		.dir_per_block_bits = 4,
+	};
+
+	sector_t blknr;
+	int offset;
+
+	fat_get_blknr_offset(&sbi, 0, &blknr, &offset);
+	KUNIT_EXPECT_EQ(test, (sector_t)0, blknr);
+	KUNIT_EXPECT_EQ(test, 0, offset);
+
+	fat_get_blknr_offset(&sbi, (10 << 4) | 7, &blknr, &offset);
+	KUNIT_EXPECT_EQ(test, (sector_t)10, blknr);
+	KUNIT_EXPECT_EQ(test, 7, offset);
+}
+
 struct fat_timestamp_testcase {
 	const char *name;
 	struct timespec64 ts;
@@ -341,6 +372,8 @@ static void fat_truncate_atime_test(stru
 
 static struct kunit_case fat_test_cases[] = {
 	KUNIT_CASE(fat_checksum_test),
+	KUNIT_CASE(fat_clus_to_blknr_test),
+	KUNIT_CASE(fat_get_blknr_offset_test),
 	KUNIT_CASE_PARAM(fat_time_fat2unix_test, fat_time_gen_params),
 	KUNIT_CASE_PARAM(fat_time_unix2fat_test, fat_time_gen_params),
 	KUNIT_CASE_PARAM(fat_time_unix2fat_clamp_test,
_

Patches currently in -mm which might be from adinata.softwareengineer@gmail.com are

kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch

