Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC31535B9
	for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2024 20:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710795053; cv=none; b=cpC0NHQ7T6nBUK4tUYHGSmRwzZ2sIaBg+cRf4cj/xfsWYinViCoZsKTgry6DeCTvw+/vKeDXYmCZ5BI4c4bw06VCzZugPnNi4SCdK6XCmExcoETxygMyChE59AohXX4EbQL6dbkIEQlM35nvPGXYfz4kMVaA+pw/HOrWPyMSQKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710795053; c=relaxed/simple;
	bh=UgBaDnvt+81Vk2rOihXZS1j6GnB1AkGMMJjnxTPdUsA=;
	h=Date:To:From:Subject:Message-Id; b=HieupcorIpfhCnhv8R0JX+jnWGgz2y2xU01wF2zwF8kCBk6RzMd0WEdha7gr8Br+wvZRdKpVG3dWN3IeHN/FBuWTkjyxQ2s61Kfle8jKONyz+joJZ3ji3t4XRSQZD4x/8Hjs73CNEtL/h9uGdoUu8Ko4gMx2faQp/XSZaxdQdkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nHSFNlE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nHSFNlE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E270C433C7;
	Mon, 18 Mar 2024 20:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1710795052;
	bh=UgBaDnvt+81Vk2rOihXZS1j6GnB1AkGMMJjnxTPdUsA=;
	h=Date:To:From:Subject:From;
	b=nHSFNlE9VIC2eU4DnbDhDBDZarRL6DhlNj3mIi4FK+9Mj6ChtxBqKPD+8W7PTNbIv
	 Ts1wkHHoXF0UNvVE9yU1xfw12WHsrqAZsXwsV3z+mVq0+SUgSW+OBnKYQcLw1S53b2
	 SXVdqf5Dz395bzbFirT/5UYM1wiWnMDvrkehjLQo=
Date: Mon, 18 Mar 2024 13:50:51 -0700
To: mm-commits@vger.kernel.org,usama.anjum@collabora.com,shuah@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch added to mm-unstable branch
Message-Id: <20240318205052.5E270C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch

This patch will later appear in the mm-unstable branch at
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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm: virtual_address_range: Switch to ksft_exit_fail_msg
Date: Thu, 14 Mar 2024 17:52:50 +0530

mmap() must not succeed in validate_lower_address_hint(), for if it does,
it is a bug in mmap() itself.  Reflect this behaviour with
ksft_exit_fail_msg().  While at it, do some formatting changes.

Link: https://lkml.kernel.org/r/20240314122250.68534-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/virtual_address_range.c |   12 ++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/virtual_address_range.c~selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg
+++ a/tools/testing/selftests/mm/virtual_address_range.c
@@ -85,7 +85,7 @@ static int validate_lower_address_hint(v
 	char *ptr;
 
 	ptr = mmap((void *) (1UL << 45), MAP_CHUNK_SIZE, PROT_READ |
-			PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		   PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 	if (ptr == MAP_FAILED)
 		return 0;
@@ -105,13 +105,11 @@ int main(int argc, char *argv[])
 
 	for (i = 0; i < NR_CHUNKS_LOW; i++) {
 		ptr[i] = mmap(NULL, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (ptr[i] == MAP_FAILED) {
-			if (validate_lower_address_hint()) {
-				ksft_test_result_skip("Memory constraint not fulfilled\n");
-				ksft_finished();
-			}
+			if (validate_lower_address_hint())
+				ksft_exit_fail_msg("mmap unexpectedly succeeded with hint\n");
 			break;
 		}
 
@@ -127,7 +125,7 @@ int main(int argc, char *argv[])
 	for (i = 0; i < NR_CHUNKS_HIGH; i++) {
 		hint = hind_addr();
 		hptr[i] = mmap(hint, MAP_CHUNK_SIZE, PROT_READ | PROT_WRITE,
-					MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 
 		if (hptr[i] == MAP_FAILED)
 			break;
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-virtual_address_range-switch-to-ksft_exit_fail_msg.patch

