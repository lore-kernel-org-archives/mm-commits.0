Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794624311;
	b=MdU/Dy/U5A5Vo226xX5hV4IpPWiUt7bxLEkEBpRy/bowIoggPM6Q3HDoSpRdnkhctm3S
	 rYfj4Ez0MOBnEq1pjk45+9iy+QGVLanC9o9ocSt6ikXhSYZR+OIC48dwwiDyR2pTxpBKk
	 1n9PN7UKdeh6N7VKz5WibQCQAYkvIDyxmpkt5lXYBbyRO3EdxPhSUF95a0FMyWspf4RHn
	 b5DKgjgjT/O/dGgQYWsv121xj+0COZU19JLXTIMnfQSwtgYchN3iabWs1I27XA5f6QeGR
	 z0DnVcTtuMMbNrB6WtkhctknCKe68CkblrQdMmsz/siuCClNrWNJdrB9lqSPm3WQUmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794624311;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=q2E8XRtcZ2uovaLi7QEhrSiMRymKImj3eiGr2usZt94=;
	b=QTumoPIhOPC6aS9bZA0Bvpq0y0VIIS2129TAHwEhF0tDI1xVN2aX1QuqHZsuYCagRDHB
	 +sBStYacG1zg/tafR9MZ5+ePMoUKLinbGXBdtNO30zpqmfq11ympsWvPcGp9xj3GenSWj
	 grin8OOHLjMVums9AwF+e0NG1XvQwjgKvmDx9Y+F3SlNGj46uEMFuSEwzaHwJ3hqvakbl
	 VLyDs7RKCBjV1lKJ838eFwbxtBn6HVRaMJq3ffEBva5ieBe2kMvMM4L6oO7Kmkhnl0+0I
	 gJECzMoUM6+4qJ/8OQYtH0IFYaMwlzGED757yIVPcm7cWARtTkWQ81Vl+G+8hKvwl/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tzI2liVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37691606A330
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 02:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=tzI2liVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6324F1F000C4;
	Sat, 14 Nov 2026 02:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794624310;
	bh=q2E8XRtcZ2uovaLi7QEhrSiMRymKImj3eiGr2usZt94=;
	h=Date:To:From:Subject;
	b=tzI2liVSWSaV49L/F/snPz49amz/fpnGMG+C0ax6wdIsalVrW8JxNiVEBwAU9geGA
	 XjZy83uiyQSlkPR+w74u5+nslyRP+0W0hlnEG1Rf8ADRN88BYW3MnBihZFJGFKFOHl
	 fUzLnD++7wFV8mjizxbxfPVdOuVkKrTyzBBzhNB4=
Date: Fri, 13 Nov 2026 18:45:09 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,hongfu.li@linux.dev,david@kernel.org,lihongfu@kylinos.cn,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch added to mm-new branch
Message-Id: <20261114024510.6324F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: mlock2-tests: fix fclose(NULL) in is_vmflag_set()
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Hongfu Li <lihongfu@kylinos.cn>
Subject: selftests/mm: mlock2-tests: fix fclose(NULL) in is_vmflag_set()
Date: Fri, 13 Nov 2026 10:52:37 +0800

is_vmflag_set() jumps to the shared 'out' label when seek_to_smaps_entry()
fails.  smaps is NULL on that path, and the code at the 'out' label calls
fclose(smaps) unconditionally.  fclose(NULL) is undefined behaviour, so
the test crashes before it can report a test result.

Return early on that error path instead, so smaps is always valid at the
'out' label.

get_value_for_name() follows the same pattern.  Return early on the
seek_to_smaps_entry() error path there as well, and drop the now redundant
'if (smaps)' guard on the fclose().

Link: https://lore.kernel.org/20261113-for-mlock2-v2-1-f62195fc8394@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <hongfu.li@linux.dev>

 tools/testing/selftests/mm/mlock2-tests.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/mlock2-tests.c~selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set
+++ a/tools/testing/selftests/mm/mlock2-tests.c
@@ -66,7 +66,7 @@ static bool is_vmflag_set(unsigned long
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
 		ksft_print_msg("Unable to parse /proc/self/smaps\n");
-		goto out;
+		return false;
 	}
 
 	while (getline(&line, &size, smaps) > 0) {
@@ -103,7 +103,7 @@ static unsigned long get_value_for_name(
 	smaps = seek_to_smaps_entry(addr);
 	if (!smaps) {
 		ksft_print_msg("Unable to parse /proc/self/smaps\n");
-		goto out;
+		return value;
 	}
 
 	while (getline(&line, &size, smaps) > 0) {
@@ -123,9 +123,8 @@ static unsigned long get_value_for_name(
 	}
 
 out:
-	if (smaps)
-		fclose(smaps);
 	free(line);
+	fclose(smaps);
 	return value;
 }
 
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch
selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch

