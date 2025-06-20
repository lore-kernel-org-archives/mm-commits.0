Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62166322E
	for <mm-commits@vger.kernel.org>; Fri, 20 Jun 2025 03:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391344; cv=none; b=F4FjPor/7rp95C/3RRJzb31/5YWPm4fzcCZAByKIug4d20FIew9qQVp9qGSyKzcFu1ztPCxzJqrmDwn69a7dt9TGpbXtz/KF+sqzQ94MHVg/VlOCTfSIW2j4Sp0VN4295b++PwQQA4iwcoRvUAmuU8sEB9ap3tECfQUTYd0fJ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391344; c=relaxed/simple;
	bh=Bb9FFIcV7e/O8Ht47TCX9IIcE8WbKTFIVTH487cs1CQ=;
	h=Date:To:From:Subject:Message-Id; b=ehG3bjrsy2bviT+U7tP+Z0GLhogrdvndhfOSS+fi5kS+nNiMbu34TyAOJU0LQl1crh2mFOun0uIwNjMybWpPQfn6Z36596YW1YOiDSbRQgA8BOqm1F38iHWeJfkSdxFDc8CfCvsr4aMy/JHJ/rKlUR9+S5caLejqex3WPCrjLss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7k9r9ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7k9r9ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53F8C4CEE3;
	Fri, 20 Jun 2025 03:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750391343;
	bh=Bb9FFIcV7e/O8Ht47TCX9IIcE8WbKTFIVTH487cs1CQ=;
	h=Date:To:From:Subject:From;
	b=p7k9r9ZVd1hUpxXBM76p/TQcg+VpHdT4djO+dRE9eCnxeJqWqR4RX8jjRs9SM50qi
	 QYVp1UWFArRQR9UujiqCYPcLyQhyZ4+8K0bQCfFmrH0DNLfAF1/j8jrorizat6BvAM
	 KaiwbH7iUIZRm91eFBd3glGt9MVQrhN7wBNd+eZI=
Date: Thu, 19 Jun 2025 20:49:03 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-increase-timeout-from-180-to-900-seconds.patch removed from -mm tree
Message-Id: <20250620034903.A53F8C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: increase timeout from 180 to 900 seconds
has been removed from the -mm tree.  Its filename was
     selftests-mm-increase-timeout-from-180-to-900-seconds.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: selftests/mm: increase timeout from 180 to 900 seconds
Date: Mon, 9 Jun 2025 12:06:07 +0000

The mm selftests are timing out with the current 180-second limit.
Testing shows that run_vmtests.sh takes approximately 11 minutes
(664 seconds) to complete.

Increase the timeout to 900 seconds (15 minutes) to provide sufficient
buffer for the tests to complete successfully.

Link: https://lkml.kernel.org/r/20250609120606.73145-2-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/settings |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/settings~selftests-mm-increase-timeout-from-180-to-900-seconds
+++ a/tools/testing/selftests/mm/settings
@@ -1 +1 @@
-timeout=180
+timeout=900
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-use-folio_expected_ref_count-helper-for-reference-counting.patch

