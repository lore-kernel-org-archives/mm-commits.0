Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E355129A69
	for <mm-commits@vger.kernel.org>; Wed,  8 May 2024 17:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715189047; cv=none; b=dWa2e8NR0X2/fNyI4Owrm0Iu+9rkSpzazXRQpb99fX0s6vO7HHMoNVazszFqoto6GnAZ4F+UteiGSsvwoZ8GgkWdOD9PADWO2CPxvTVfZzdYY8ptC4RnpHlRuny5EIY+taWWMeqVVi4DN50EpbYheCmryyQu0vIbOSsuYfSO+yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715189047; c=relaxed/simple;
	bh=laZaeshLQrFS3GtwXEnNxcflBr77FfoDJWFfd8rflAo=;
	h=Date:To:From:Subject:Message-Id; b=DMeXapKs/9j9f4UJONFakN5i7moz30H7H7Vh2kjLa2ilC3FdpAUMvpKBeTn374FDwNT4SYtX/fSXOAMOpsGeDTthWOv/ZVlpqCnF8E+odJ0ZZm5ah8ES6kaoknxbi9tCnJWS5ZQLhuVbhnhIlDfXD82V4raXA+vAa8hnnaUUi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YTVVbsU0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YTVVbsU0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11AAC113CC;
	Wed,  8 May 2024 17:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1715189047;
	bh=laZaeshLQrFS3GtwXEnNxcflBr77FfoDJWFfd8rflAo=;
	h=Date:To:From:Subject:From;
	b=YTVVbsU033MJdxyPMv3d4GM5Y5uYU84z701ltlHZGMhoJJ/bdkun9i5oj7aZ5TfQ1
	 mrVjNYGGjnf7sLSaaiHVJBiGAvSwwDIj1iImm+88l0PHb0JLIf1O+dlBEin89oaOAR
	 uwsfsAiMWMzpJtzodjasZZ35yErr7pgwmEUKYBWg=
Date: Wed, 08 May 2024 10:24:06 -0700
To: mm-commits@vger.kernel.org,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch removed from -mm tree
Message-Id: <20240508172406.E11AAC113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
has been removed from the -mm tree.  Its filename was
     mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Jane Chu <jane.chu@oracle.com>
Subject: mm/madvise: add MF_ACTION_REQUIRED to madvise(MADV_HWPOISON)
Date: Wed, 1 May 2024 17:24:57 -0600

The soft hwpoison injector via madvise(MADV_HWPOISON) operates in a
synchrous way in a sense, the injector is also a process under test, and
should it have the poisoned page mapped in its address space, it should
legitimately get killed as much as in a real UE situation.

Link: https://lkml.kernel.org/r/20240501232458.3919593-3-jane.chu@oracle.com
Signed-off-by: Jane Chu <jane.chu@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-madvise-add-mf_action_required-to-madvisemadv_hwpoison
+++ a/mm/madvise.c
@@ -1147,7 +1147,7 @@ static int madvise_inject_error(int beha
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
-			ret = memory_failure(pfn, MF_COUNT_INCREASED | MF_SW_SIMULATED);
+			ret = memory_failure(pfn, MF_ACTION_REQUIRED | MF_COUNT_INCREASED | MF_SW_SIMULATED);
 			if (ret == -EOPNOTSUPP)
 				ret = 0;
 		}
_

Patches currently in -mm which might be from jane.chu@oracle.com are

mm-memory-failure-send-sigbus-in-the-event-of-thp-split-fail.patch

