Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794624260;
	b=V/fg0AFGJsv0I6KO0F8Bb+LAYtiuKOgGwxqX67D16xMpLz4sHUpPHc/6fdvBP2L5ygMk
	 ZOR2irspV3VQHqlyyeDqQMhCaGHv1c65RZ4hRoCMOttPSZ6yZ/pNsuuZoN9QuJeM7wNzZ
	 WExiisXbJ3OWYRkI5xPlxBo3eRWeNOpg8tv72E7SI+crsN38BgMOs1oqlNLiCzbeH1KF8
	 RtVkTTlSWMtQCLYjL05PDow4iCAlplZGM73md1EbV4w6Zgt7wrFJXMRPdOh/T8brWITjZ
	 an0fIwEgiSQev70NfSGmgmMsahxFzRONq7oe5r4VWm37TqZCaogZu3ozoqLgTbpRCMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794624260;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Wpg+fQnEdcY55E43ajOc9tJ89ywGCQoPoWKnGW35kG0=;
	b=c0dnjSvH9ZYBCQJ1Oay5lDLAAADTC9rTWQtQoShP7jIHyhInHXMNMdcGYF2y+O2EZ4d2
	 xP6Dl3EiTaW/q15AynbuZ6aVQHhyafTVL4kXxVbNcTH5jIzYUUcYYZ7viaCqQQ3MvAp7L
	 ZnkYq0MRUq0OdNfVpxD8KXrs6Nh77bfI3aks83x62QY903zMA3OaKDHjtgnvob5zXKTkx
	 C9Ac1lE9+L/1lBoLfDmT77gf1pIKvgpeurgvJZgx1uGfecWW+g4uTIX4X3lk45RY632cr
	 FPi0kNTQ8OzQzRBs9Yhba5trEDwdTD+t6z+jTJa5yO+IXV4lLlPRasha2bkdH7UDPLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eEC8T2c6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3194C606A32D
	for <mm-commits@vger.kernel.org>; Sat, 14 Nov 2026 02:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=eEC8T2c6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B231F000C4;
	Sat, 14 Nov 2026 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794624259;
	bh=Wpg+fQnEdcY55E43ajOc9tJ89ywGCQoPoWKnGW35kG0=;
	h=Date:To:From:Subject;
	b=eEC8T2c6EOZHvwZzn33x79WbTnvnAceU2srzn0MM5EVkgQwEN5GYbjKax3YxQDqrp
	 iuEOk5brdXM/XAVkQqrQq0Blt7phm2K3ZLPFDT6IAAdlMFhLrn0Ky7wy8EO/tDzHsD
	 QzHg4vC5F/EqoIrIueS0EcON9Hck8jcsKpVTyBcA=
Date: Fri, 13 Nov 2026 18:44:19 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,
	liam@infradead.org,david@kernel.org,akpm@linux-foundation.org,
	lihongfu@kylinos.cn
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch removed from -mm tree
Message-Id: <20261114024419.90B231F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: mlock2-tests: fix fclose(NULL) in is_vmflag_set()
has been removed from the -mm tree.  Its filename was
     selftests-mm-mlock2-tests-fix-fclosenull-in-is_vmflag_set.patch

This patch was dropped because an updated version will be issued

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

mm-hugetlb-charge-hugetlb-cgroup-and-memcg-in-alloc_hugetlb_folio_reserve.patch

