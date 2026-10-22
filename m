Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792702089;
	b=i06Mw25AIT4N+LGWtPtdb+XYTg63ocdk6ZZ/BCQBdlagR/KT/ozfcuIPkpZNSHnm4EP4
	 aBM5XCzN64z3la47pF/ul20ksfT13o3AxFB9wdqWXqsAc3jri5y8zfggiKDyvL0tfTJV8
	 sIl7ByAyFEsM869iMgQiGVRUmWQCQNhw6+qlzFL/yMSWquzVpNY6sbjVEljL+OkjRwLFx
	 I5d3lfb2p2dxVemWgX2BhvXcb6hIo+SPke5/xS+7FvJApvTKeX8UnHa4NEG+j5Gaer8g5
	 aiX3PtF9gUho6oAgdCDlrBqCUfkWCme8j2dujhLqMSRBgChLr/Odf36F3qE16AVaixg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792702089;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=hstwqGu09N6A0xBwbO1VBrRPmy17n6yOesepkVhHXUI=;
	b=b1N6/cOU1Op0PSga2chM09Q1DBsUtP0p7gft3MTfRS+q6Jq6cKYwTnwMCa828l5mI2mV
	 IZ8fwCTT71Xw8fRBBD8vKGNpJzyLWMJvibDZqLoMrkvAffu4u1msAoh4WPW63Z7ajhxUv
	 RWIzEjxotQwcPifwL0WkCEsEwJ6Ul/mrRd1NvLj0nTvQUmstu5cAnWxmQpMg31b9UOFPk
	 BVwpmzIiuJG4rEKEn7FSXTEv3eWUa6eYUSihLPDCAqezoI3jC/oZ63mQioODnDcQAKpZ4
	 rE5nMV2S6mkRQsnsEAxfJCwao9l5vod5K4BDuVY+KcqQjZ/HZYUyOQWGPioT7fLCG7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B909606A325
	for <mm-commits@vger.kernel.org>; Thu, 22 Oct 2026 20:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6C11F01825;
	Thu, 22 Oct 2026 20:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792702088;
	bh=hstwqGu09N6A0xBwbO1VBrRPmy17n6yOesepkVhHXUI=;
	h=Date:To:From:Subject;
	b=VjRSN2RDE09axN8OL10SHY8e/fUFVHUfZsMwv7ZvFgWd7LCw4NTUoaTgS/DhFe/ld
	 +y45NKeRgHjoImgxs6gG/0KJ11wSkFJTuEUp63nDicS5mlp8d5lnhNjP/antgWzHXE
	 7Uh7l+t31WgL3rXGoOUHYj0kI9NEfrCcigM2w8bU=
Date: Thu, 22 Oct 2026 13:48:07 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leitao@debian.org,guillaume@morinfr.org,david@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch removed from -mm tree
Message-Id: <20261022204808.0D6C11F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
has been removed from the -mm tree.  Its filename was
     selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: selftests/mm: hugetlb_madv_vs_map: fix TAP plan mismatches
Date: Mon,  5 Oct 2026 01:00:18 +0200

The plan was raised from 1 to 3, but the HugeTLB setup check that may call
ksft_exit_skip() still runs after ksft_set_plan(), so a setup failure
reports one result against a plan of 3.  Move ksft_set_plan() below the
setup check.

Also, when the underflow check fails, or munmap() fails, test_underflow()
jumps to err_cleanup and exits without reporting the remaining results. 
Report the munmap() failure as a test result and skip the final
HugePages_Rsvd check in err_cleanup, so the output always contains the
planned 3 results.

Link: https://lore.kernel.org/20261004230018.190880-1-jaeyeon.lee.dev@gmail.com
Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: LLM
Cc: Guillaume Morin <guillaume@morinfr.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
---

 tools/testing/selftests/mm/hugetlb_madv_vs_map.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c~selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches
+++ a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
@@ -169,6 +169,7 @@ void test_underflow(void)
 	/* First unmap, this will close the vma */
 	if (munmap(huge_ptr, mmap_size) != 0) {
 		ksft_perror("munmap failed");
+		ksft_test_result_fail("munmap failed\n");
 		goto err_cleanup;
 	}
 
@@ -203,18 +204,20 @@ err_cleanup:
 	if (waitpid(pid, NULL, 0) <= 0)
 		ksft_exit_fail_perror("waitpid failed");
 
+	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
 	ksft_exit_fail();
 }
 
 int main(void)
 {
 	ksft_print_header();
-	ksft_set_plan(3);
 
 	if (!hugetlb_setup_default_exact(1))
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
 			       hugetlb_free_default_pages());
 
+	ksft_set_plan(3);
+
 	test_madv_vs_map();
 	test_underflow();
 
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch
mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

