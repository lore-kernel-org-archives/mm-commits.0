Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2E218C02E
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865928; cv=none; b=A50BpUuIyQBLZCIDc7Z7ZUmFwlxJL5sAr5pj0KjsEn/i6xrC9VeP8CMqY3lPaxKgCld/AJYQGd82+mfI5Ui+Jr5z7egIw/N3DzJfYkpCgiLEhjLAv6Krdm5NZnrJIcNyK1WcECRMLfxQGahZUjwf/D5kVX6wE790624M9tTQC0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865928; c=relaxed/simple;
	bh=a2hQo0eBENBsg6QJKI21Yd0yZf5mo1ZSEHjB+yLITmQ=;
	h=Date:To:From:Subject:Message-Id; b=kGVpNqLKhewWOY9NXeRy6pJqhhdQdVdU8g/h+cNB/MRfqyy/AirIaL3vT06K3jwak4GTiPugEshUdXAKqYkD7fE74CL39VxVkvuQo/dzKk2y6ajHK+uFUW6oXsQGcudmdtkWre4ZnkgqhTXb+wLgIguxHI+RegLuEt0/jd5jOAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Un5Wkibc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Un5Wkibc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7171F00893;
	Tue, 13 Oct 2026 04:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865927;
	bh=7xKanlr9qBZ/JG9v2kLlzG3h/v0cKB8lPvxTOowF/KQ=;
	h=Date:To:From:Subject;
	b=Un5Wkibc9Zk2uyXvcDpp4p5YM/gcgRO+fQ9XcD9YHwNL1fcPj/fecOOaiAPCz4FEe
	 1VM+Js1bRIBc3j4s6Tw3cF8FxWQ02pduxCP/cuXodYzuw7vbNIufMDKbE1TJParZE2
	 rz3bnzDlN3foLFFVKD4FJ0IN2CQUuG41nQhrpjio=
Date: Mon, 12 Oct 2026 21:32:06 -0700
To: mm-commits@vger.kernel.org,weiyongjun1@huawei.com,rcampbell@nvidia.com,leon@kernel.org,jglisse@redhat.com,jgg@ziepe.ca,apopple@nvidia.com,error27@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hmm-test-reject-overflowing-page-counts.patch removed from -mm tree
Message-Id: <20261013043207.2C7171F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hmm/test: reject overflowing page counts
has been removed from the -mm tree.  Its filename was
     mm-hmm-test-reject-overflowing-page-counts.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dan Carpenter <error27@gmail.com>
Subject: mm/hmm/test: reject overflowing page counts
Date: Tue, 15 Sep 2026 19:37:27 +0300

The number of pages comes directly from userspace.  Shifting a value
larger than ULONG_MAX >> PAGE_SHIFT discards its high bits before the
existing end-address check.  A request for a huge number of pages can
therefore be accepted and processed as a much smaller request.

Reject page counts that cannot be represented as a byte size before
performing the shift.

So far as ChatGPT and I can tell this doesn't cause an issue in practice
but preventing this integer overflow is the correct thing to do.

Link: https://lore.kernel.org/6f0d39089e938d4f53dc72632eb84aca34de7015.1789457465.git.error27@gmail.com
Fixes: b2ef9f5a5cb3 ("mm/hmm/test: add selftest driver for HMM")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Assisted-by: ChatGPT:gpt-5
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
---

 lib/test_hmm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/test_hmm.c~mm-hmm-test-reject-overflowing-page-counts
+++ a/lib/test_hmm.c
@@ -1624,6 +1624,8 @@ static long dmirror_fops_unlocked_ioctl(
 
 	if (cmd.addr & ~PAGE_MASK)
 		return -EINVAL;
+	if (cmd.npages > ULONG_MAX >> PAGE_SHIFT)
+		return -EINVAL;
 	if (cmd.addr >= (cmd.addr + (cmd.npages << PAGE_SHIFT)))
 		return -EINVAL;
 
_

Patches currently in -mm which might be from error27@gmail.com are


