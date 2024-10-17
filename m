Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54CE81C6F66
	for <mm-commits@vger.kernel.org>; Thu, 17 Oct 2024 07:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729150143; cv=none; b=hD193C77dUI8EIykOxFaevUHbqrKnCHAsHgXXiMi/tgDXMwcuQiRzNwiQ/LE1HBcQPgbvFwjeBvzF9lMw+Uqhi5ut/UVWVJ6P1/0NjbaB0RWb8ZbEqz2eqw/PD/fV2DIRqMSsVK3qxWYqm5Al6KeH0LFx4RCmTX5DkX6aFkNN84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729150143; c=relaxed/simple;
	bh=IhkVM3m+d3fYOXKnuvxX+CZBr6s1ezt7+M62TjGQziE=;
	h=Date:To:From:Subject:Message-Id; b=T4/Z7Io12l9ltBTJEYlMVTS9FkjgCukmKu/e+DqxDOSN9lHmjuEyMzFdRlLCQ3x77iYktJiVgbjEI5iT6Wolyukz4DNobrJLwoJb6bjpG3yaiR2zEFMWGtKVQ1GUyZcLHeU3jWxv35X90kUgroe5fTumel3NQ+t1iyNliBgVe8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J/wVVx93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J/wVVx93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD824C4CEC3;
	Thu, 17 Oct 2024 07:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729150143;
	bh=IhkVM3m+d3fYOXKnuvxX+CZBr6s1ezt7+M62TjGQziE=;
	h=Date:To:From:Subject:From;
	b=J/wVVx93P1nyHq2Y+Pt3T6t0QqQFYN5lxA/pfASm75YGFN7H3S6WUN+fptyVmqrfo
	 S5SiturEzKIKrYU7twANFKTRB9l1Z0FsZK6BO8vWYMMq8rqFECNJnU3ePxas1iknhp
	 mv8Wab8EcpQVuOsWzJtKpOUrgpyZKLf/FwC+6AKc=
Date: Thu, 17 Oct 2024 00:29:02 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,wangkefeng.wang@huawei.com,shuah@kernel.org,baolin.wang@linux.alibaba.com,anshuman.khandual@arm.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-the-incorrect-usage-info-of-khugepaged.patch removed from -mm tree
Message-Id: <20241017072902.DD824C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests: mm: fix the incorrect usage() info of khugepaged
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-the-incorrect-usage-info-of-khugepaged.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: selftests: mm: fix the incorrect usage() info of khugepaged
Date: Tue, 15 Oct 2024 10:02:57 +0800

The mount option of tmpfs should be huge=advise, not madvise which is not
supported and may mislead the users.

Link: https://lkml.kernel.org/r/20241015020257.139235-1-sunnanyong@huawei.com
Fixes: 1b03d0d558a2 ("selftests/vm: add thp collapse file and tmpfs testing")
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Zach O'Keefe <zokeefe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-fix-the-incorrect-usage-info-of-khugepaged
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1091,7 +1091,7 @@ static void usage(void)
 	fprintf(stderr, "\n\t\"file,all\" mem_type requires kernel built with\n");
 	fprintf(stderr,	"\tCONFIG_READ_ONLY_THP_FOR_FS=y\n");
 	fprintf(stderr, "\n\tif [dir] is a (sub)directory of a tmpfs mount, tmpfs must be\n");
-	fprintf(stderr,	"\tmounted with huge=madvise option for khugepaged tests to work\n");
+	fprintf(stderr,	"\tmounted with huge=advise option for khugepaged tests to work\n");
 	fprintf(stderr,	"\n\tSupported Options:\n");
 	fprintf(stderr,	"\t\t-h: This help message.\n");
 	fprintf(stderr,	"\t\t-s: mTHP size, expressed as page order.\n");
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

mm-move-mm-flags-to-mm_typesh.patch

