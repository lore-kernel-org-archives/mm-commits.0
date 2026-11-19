Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062159;
	b=Y66G7q2no8t8ixE0q7yTDmh7OuIPQHa7/XAp6YSamufCR+cPXTU1Vw+mGs5eUt/n9IL5
	 w+9VnQLgC+gTIOUDhxqP+lFmqoJBTqiyayfchT2VcoKnyQz5KNdGDbEDyB0SYvteRdCJl
	 jUY+d8XwtFwN8Ja1jbQfDMVPLyd59InWWDmn51ETAUTrmNyaBFTpU0ZrnguV1Mv6QbFut
	 Lft3y8VpEJ2U4Ud8G5VBQ9oWKSlDY+pilQRhtJA5EhN3vnlgGsMkgL9fixLJWmileYWxG
	 ljv26ARW1wZ1Kmx72+UHY6f3YuLlP+g9LdVJRLMzhBB477mDhTqPT5j0GyqtSRHnjGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062159;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Lr7YBeac4vwTMD7hLmzicpDrtwS6sLKl7+BpU79LCe8=;
	b=UvnCqeMhTdL1/NJasn+lAr4ct3vJUYzoOHlTzGQutUE199lhZq29qcayYeyPGpAFSk++
	 0lUyEBs9X82IkqxLGTA1hHbmDF2kygi3xHypXUkmxGenKOhGe+Cc/odK7SngMR67awPui
	 FU3LCDinXvlbOo6VrsAh4GpNkNLW8xRW9nqufg42IC8HZl/Oatr8cFDcf3v6RTSn9oNGE
	 YkOBMfeCLvAciOH0sVjne7qFuEpJ3XUkG9g5Sg01FGDDabBOMW7IqZyXtpHlNmZv4/WNw
	 cRlpvkEarkjC6Ckhu2ANitu6V3K6iCuHEQbFz3ImlD54jhnX80YKyd/tFO0ZjQ7ofZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCTBOi13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F12606A339
	for <mm-commits@vger.kernel.org>; Thu, 19 Nov 2026 04:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fCTBOi13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1FD1F000C4;
	Thu, 19 Nov 2026 04:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795062159;
	bh=Lr7YBeac4vwTMD7hLmzicpDrtwS6sLKl7+BpU79LCe8=;
	h=Date:To:From:Subject;
	b=fCTBOi130XSY6fVGz8E0HriC04CVDzlgm+dHkiwPBVF/Pk67pMZ8SWovur98S4pbM
	 2MdGo7hEXWrFAoQs5nLlTPZWQmheh6lW5HpUKJ6NtBwhJj4vZ/LfOsT3JdjRopWu4I
	 LGRsohl1L3Kw5z42kIV4znhAK1iSOw+K6q5a7W54=
Date: Wed, 18 Nov 2026 20:22:38 -0800
To: mm-commits@vger.kernel.org,swarupkotikalapudi@gmail.com,shuah@kernel.org,
	kevin.brodsky@arm.com,clopez@suse.de,adobriyan@gmail.com,lylin1023@gmail.com,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch removed from -mm tree
Message-Id: <20261119042239.2B1FD1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/proc: proc-empty-vm: handle CPUs without protection keys
has been removed from the -mm tree.  Its filename was
     selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kurt Lin <lylin1023@gmail.com>
Subject: selftests/proc: proc-empty-vm: handle CPUs without protection keys
Date: Mon,  9 Nov 2026 23:19:12 +0800

On x86 CPUs without protection keys, pkey_alloc() fails with ENOSPC,
as documented in pkey_alloc(2). protection_key_support() only expects
ENOSYS or EINVAL, so the test fails on such machines, e.g. an Intel
Core i5-7200U:

  protection_key_support: error: rv -1, errno 28

Treat ENOSPC as "no protection key support" as well.

An AI coding assistant (Claude) was used to analyze the failure and to
draft the fix and this changelog. Tested on v7.4-rc1 on the machine
above; the test now passes.

Link: https://lore.kernel.org/20261113154411.568272-1-lylin1023@gmail.com
Link: https://lore.kernel.org/20261109151912.156518-1-lylin1023@gmail.com
Fixes: bf5add391eeb ("proc: test ProtectionKey in proc-empty-vm test")
Signed-off-by: Kurt Lin <lylin1023@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Swarup Laxman Kotiaklapudi <swarupkotikalapudi@gmail.com>
Cc: Carlos López <clopez@suse.de>

 tools/testing/selftests/proc/proc-empty-vm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/tools/testing/selftests/proc/proc-empty-vm.c~selftests-proc-proc-empty-vm-handle-cpus-without-protection-keys
+++ a/tools/testing/selftests/proc/proc-empty-vm.c
@@ -78,6 +78,9 @@ static int protection_key_support(void)
 	} else if (rv == -1 && errno == EINVAL) {
 		// ospke=n
 		return 0;
+	} else if (rv == -1 && errno == ENOSPC) {
+		// CPU without protection keys
+		return 0;
 	} else {
 		fprintf(stderr, "%s: error: rv %ld, errno %d\n", __func__, rv, errno);
 		exit(EXIT_FAILURE);
_

Patches currently in -mm which might be from lylin1023@gmail.com are


