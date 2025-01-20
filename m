Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C235DDD2
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 01:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737337155; cv=none; b=Eu2tTTluCw8TXHzZJCDx7npFfhotEisp1cE68WLfb6NcRv3THuIETNNmbbtQDMX9Zme824hmpPRSU/uE5IJuGMciu/wG1Xajw9Masv2U5vIevNNAGeLsDHYVYZ/UiaZ2w2xyZMqrNUmwuadXrS6bnCrrk/oHwqBqfQ6DTFzOSdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737337155; c=relaxed/simple;
	bh=pRvIfzg0GP6Ad94W6OjiI0KMKEuPjkPOANNI5nMLuuU=;
	h=Date:To:From:Subject:Message-Id; b=eCYO3srbfoO5cx5pWksgGRCg5Lm0JZ+DnhE4iQ0K9GGYY6a6tfEkk437lptHt0oHRYEMa+P89RMzCbqRnxto9BQJpPMYqBxGpDS3Fty0ZQ1Dd4tgwFA+mfhFPxvccNhxRLnC0kcPXt9Cm+Crwm1PfSLURz6HAMCnqVSPZhpDuyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XUVpPzeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XUVpPzeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F9FC4CED6;
	Mon, 20 Jan 2025 01:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737337155;
	bh=pRvIfzg0GP6Ad94W6OjiI0KMKEuPjkPOANNI5nMLuuU=;
	h=Date:To:From:Subject:From;
	b=XUVpPzeJ7FeHWOBEHVw/Iw2yqg3kPt0lEf21rioupx3UYGadwEN3n2kC1P1tVZBUo
	 TiqqZlVI17uhn/6hZK9cNSPUqM5nqP4bPC+WfrJaLr74F06mI3Iprq0hcYxpe6yJwd
	 xQvzO+4gA4Am/TWo7J+X2MmtyGEp7faI0koMX7NM=
Date: Sun, 19 Jan 2025 17:39:14 -0800
To: mm-commits@vger.kernel.org,shuah@kernel.org,sauravshah.31@gmail.com,lorenzo.stoakes@oracle.com,jeffxu@google.com,isaacmanjarres@google.com,gthelen@google.com,liuye@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch removed from -mm tree
Message-Id: <20250120013914.E6F9FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/memfd/memfd_test: fix possible NULL pointer dereference
has been removed from the -mm tree.  Its filename was
     selftests-memfd-memfd_test-fix-possible-null-pointer-dereference.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: liuye <liuye@kylinos.cn>
Subject: selftests/memfd/memfd_test: fix possible NULL pointer dereference
Date: Tue, 14 Jan 2025 11:21:15 +0800

If `name' is NULL, a NULL pointer may be accessed in printf.

Link: https://lkml.kernel.org/r/20250114032115.58638-1-liuye@kylinos.cn
Signed-off-by: liuye <liuye@kylinos.cn>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Saurav Shah <sauravshah.31@gmail.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/memfd/memfd_test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/memfd/memfd_test.c~selftests-memfd-memfd_test-fix-possible-null-pointer-dereference
+++ a/tools/testing/selftests/memfd/memfd_test.c
@@ -171,7 +171,7 @@ static void mfd_fail_new(const char *nam
 	r = sys_memfd_create(name, flags);
 	if (r >= 0) {
 		printf("memfd_create(\"%s\", %u) succeeded, but failure expected\n",
-		       name, flags);
+		       name ? name : "NULL", flags);
 		close(r);
 		abort();
 	}
_

Patches currently in -mm which might be from liuye@kylinos.cn are

mm-vmscan-fix-hard-lockup-in-function-isolate_lru_folios.patch

