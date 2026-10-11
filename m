Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C91D740A920;
	Sun, 11 Oct 2026 22:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791757192; cv=none; b=FpsvGMij+d+G7oUI3iukMmbRosg4ZY6E3/SGRhlCSLqQIEcGV8Wfn3Fta4XSrKq0Yl25Fkha1k8WupCSI7oacHc+foC4pTbx5cJwt5W4b8L510WO2StUzmdkdW8eyuC3tuWutiW+IciL19pyj85aOhQ+BumjcvVfWgJaYmjTiRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791757192; c=relaxed/simple;
	bh=l29gGX8zyRkmmVORtLzKO8gUjw3n+rbrxHPJnaNuISo=;
	h=Date:To:From:Subject:Message-Id; b=leZjgVg5r3DIxTCS2gDNmY2fCly3jB0uyDQiO2ekagYcLkbFIusNW+dtkai1YW5MNOo4eoTgxvDbQYkTTDf7T+HUXuScv2LCE/KcCPv0+YL6Djhhwq/Cg4SJTRQMOlQY1T3EVJS0UM88YpXwSKu3vOvCXjx43xKaZNz13Hy5Vd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BW85+b2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BW85+b2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9091F0089C;
	Sun, 11 Oct 2026 22:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791757191;
	bh=cS3hnhxffWiXcHtAejMtY+TPmTgFy214zwhHa4n0tPI=;
	h=Date:To:From:Subject;
	b=BW85+b2T1VhqgyA1r2DblrZqw2K2w6oiPaqXW8mCvmi+vjvTUaXd0PXFDueiiiXh8
	 QjWa+7hYaw7q475EsDiFmz0KmdB/wvRrNagr4CwDx4SZa97T33TqNOeKzwGxL67/zY
	 ORLvcHMzaOeEPkce1YhkAZm6AgOR5TUeqCp9EtFw=
Date: Sun, 11 Oct 2026 15:19:51 -0700
To: mm-commits@vger.kernel.org,tchibo@google.com,stable@vger.kernel.org,glider@google.com,elver@google.com,dvyukov@google.com,andreyknvl@gmail.com,fangxy@xiaopeng.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch removed from -mm tree
Message-Id: <20261011221951.6E9091F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kcov: ignore an out-of-range comparison count in write_comp_data()
has been removed from the -mm tree.  Its filename was
     kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fang Xieyan <fangxy@xiaopeng.com>
Subject: kcov: ignore an out-of-range comparison count in write_comp_data()
Date: Thu, 17 Sep 2026 18:43:06 +0800

write_comp_data() reads the comparison record count from area[0] and uses
it to index the coverage buffer:

	area = (u64 *)t->kcov_area;
	max_pos = t->kcov_size * sizeof(unsigned long);

	count = READ_ONCE(area[0]);

	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
	start_index = 1 + count * KCOV_WORDS_PER_CMP;
	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
	if (likely(end_pos <= max_pos)) {

The buffer is mmap'd writable into the collecting process, so count is
under its control and end_pos <= max_pos is its only bound.  A count that
wraps the u64 multiply leaves end_pos below max_pos, so the check passes
while the record store lands 24 bytes before the buffer, in the unmapped
vmalloc guard page, and faults:

  BUG: unable to handle page fault for address: ffa0000000b60fe8
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  Oops: 0002 [#1] SMP KASAN NOPTI
  RIP: 0010:write_comp_data+0x7e/0xa0
  ...
  Kernel panic - not syncing: Fatal exception

Bound count first: only max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP)
records fit, so a larger count is not a valid index and is dropped. 
kcov_move_area() bounds the same untrusted count this way, and no count
the end_pos <= max_pos check accepts reaches that limit, so no valid
record is lost.

kcov is a root-only debugfs file (debugfs_create_file_unsafe("kcov", 0600,
...)) and write_comp_data() exists only under
CONFIG_KCOV_ENABLE_COMPARISONS, so this is a local, debug-kernel
robustness fix: the process corrupts its own buffer and the kernel oopses.
It crosses no privilege boundary.  Additional details at [1]

Link: https://lore.kernel.org/20260917104306.22145-1-fangxy@xiaopeng.com [1]
Fixes: ded97d2c2b2c ("kcov: support comparison operands collection")
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alexander Potapenko <glider@google.com>
Assisted-by: Hawkeye:GLM-5.3-flash
Assisted-by: Qoder:Qwen3.8-Max
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Victor Chibotaru <tchibo@google.com>
Cc: <stable@vger.kernel.org>
---

 kernel/kcov.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/kcov.c~kcov-ignore-an-out-of-range-comparison-count-in-write_comp_data
+++ a/kernel/kcov.c
@@ -253,6 +253,14 @@ static void notrace write_comp_data(u64
 
 	count = READ_ONCE(area[0]);
 
+	/*
+	 * area[0] is writable by the collecting process, so count cannot be
+	 * trusted. Bound it to the records that fit, as kcov_move_area()
+	 * does, so the end_pos multiply below cannot wrap past its check.
+	 */
+	if (count >= max_pos / (sizeof(u64) * KCOV_WORDS_PER_CMP))
+		return;
+
 	/* Every record is KCOV_WORDS_PER_CMP 64-bit words. */
 	start_index = 1 + count * KCOV_WORDS_PER_CMP;
 	end_pos = (start_index + KCOV_WORDS_PER_CMP) * sizeof(u64);
_

Patches currently in -mm which might be from fangxy@xiaopeng.com are


