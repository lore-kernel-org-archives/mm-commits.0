Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793813039;
	b=YuoC3yd41s63e++WQSqO+zQok+c5FAPcP6xkJ+Y4gbdja1SalRC1jn/t5e4d/0B5DgP9
	 pzpiA/VSfAy7j3s6INm+oNgrFzI0rdpAg3vS9Lr6X6/ecWGKrMylbSZoh97CLlaRzxcW9
	 E+TpDDlK7eRt7xhqxsJm8ZgVLsy1KLrfmuwF5E5VN0eXS3w/kbJQXJF1IigAD/mO6lnso
	 STS1LcHbGPjfbOf3A20n3T3o23Nuz9QtN2O6gecn1URp+pDqcDWXGb60IGWRGb+LLjRY8
	 M3g5pvODfDbgTMZ4kOLByw3kvhhtoD4KQ28CcC7msk9BnEQG/1JnCwarAyXLBiKqTLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793813039;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=IdTT5JG103JB9Z+HqWvs3AuYAAXRJtN3EEU2MOO6944=;
	b=TDlBpNQ1VpQMKUKGTDVGasFF05RUykWN5zMzWFIVKHR7nUmYO+ZlPUAqye08biI3sPdv
	 wJgGHy48HUIHfFP0zZJ9nFFIY1EDdBz63YVeH3Hbt0ap82GTIppslb8JF18UUjqo4ifjz
	 wiu2W/pYim7Bo5nBWDqJBMMsExV39371hLoV9NeJ6NLpm1KsFeF4lEqIrbCyWDBhnRP8t
	 5kPidQrINWph/kbJYqhzC4iIyGnjyeEkIRKP87oNPp/K5DkI+UlrFzeIKIhtUVncbQYaw
	 bKyJ0+BXxaMm3DfJEoDR5kxVl9gxWQM5SuJiYAflxT4FVRO2w+/EUHAvOv/a7U0hqGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MJoSmopS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E8B606A326
	for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2026 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=MJoSmopS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55C91F000C1;
	Wed,  4 Nov 2026 17:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793813039;
	bh=IdTT5JG103JB9Z+HqWvs3AuYAAXRJtN3EEU2MOO6944=;
	h=Date:To:From:Subject;
	b=MJoSmopS7oZwkYkR/9NoOQD4R7lAEvXdC1X1H3pfnwshRzwN941sWv/Tn7RVP/i7x
	 VCgPfInLFJo2N4qnjVLer7r1zPFlHCk03KdcsRFkhT9MQNO/exG1VVwo0Jws0adI7K
	 uaURsW1ItI8xDGmp1505qcrLlnw69uxMmTUHVq0M=
Date: Wed, 04 Nov 2026 09:23:58 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,
	lihongfu@kylinos.cn
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch added to mm-new branch
Message-Id: <20261104172358.E55C91F000C1@smtp.kernel.org>
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
Date: Wed, 04 Nov 2026 16:49:10 +0800

is_vmflag_set() jumps to the shared 'out' label when seek_to_smaps_entry()
fails.  smaps is NULL on that path, and the code at the 'out' label calls
fclose(smaps) unconditionally.  fclose(NULL) is undefined behaviour, so
the test crashes before it can report a test result.

Link: https://lore.kernel.org/20261104-for-mlock2-v1-1-57e6dd74c2bd@kylinos.cn
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/mlock2-tests.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
_

Patches currently in -mm which might be from lihongfu@kylinos.cn are

selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch

