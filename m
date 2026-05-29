Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2FE371867
	for <mm-commits@vger.kernel.org>; Fri, 29 May 2026 04:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780028740; cv=none; b=UxPica4XzqwPSl5hQs4ZJ5ya20uOWr/RMi0jrFKZespJ3JloLfhZ+vhQtbwYqkIneSgd4TSiPYOCQn8LYm6Omt2Li264Mfq6+G8ZHa/uslrawrkEs+yYRuLSmI5dBAHQiidfR4Ne6pz4yqd+yqgJMMUUj6tbpUnPQTiuFZlNVYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780028740; c=relaxed/simple;
	bh=wMm/7Jp5o/R3A980Jgnob5dUsCYbDQqZdCBu65DWNbY=;
	h=Date:To:From:Subject:Message-Id; b=kSdn43SfyBx6Z3HYWVt2nDMxtyB/Op546/iqih0LS5XFaVlnVZJO/ZqxR/c5gUo3FFrf2W7XWPGdNtrcchUYj/umzlfIarVADsxW7SwAhcgZO8zeovPMphLAac8WrsIY5Ee1jvllNPnhWiHv9IykyoeFaEFgEGPPCc0OSc8aTDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EOtKo7BV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EOtKo7BV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1448A1F00893;
	Fri, 29 May 2026 04:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780028739;
	bh=J0m1Db0+ynTZoKOhdggigNN0jf3brAkd+zgYe9kvLYs=;
	h=Date:To:From:Subject;
	b=EOtKo7BVhMrcKFL+Hy8sLOsHbwST7RjZjjuaezHVMbEKk0Pix+kqgQOCg7FeFQmUC
	 mIpWj+tpMCRSCMtogWjQM5SxA95S6yNL7gg+851QcGR5tu89qekXkqTvVhrQaigWom
	 NvIMCvaph+wicxmToOYid2sSSTwjPSmQTJe12eBs=
Date: Thu, 28 May 2026 21:25:38 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,adinata.softwareengineer@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch removed from -mm tree
Message-Id: <20260529042539.1448A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kunit: fat: test cluster and directory i_pos layout helpers
has been removed from the -mm tree.  Its filename was
     kunit-fat-test-cluster-and-directory-i_pos-layout-helpers.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


