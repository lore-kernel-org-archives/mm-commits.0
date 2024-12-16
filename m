Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7568192B70;
	Mon, 16 Dec 2024 06:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734329160; cv=none; b=FG1NMO+H7oSox2b9s11CQQYWgQgw6I73cRJz4S2HA8R/8qpxAIAh/xfCO6FKmWQNWKqzyl0ucHxAZm/MFRoSZCAbwmdqvG0KQeC/+F2FVbOnMXq5KmB3ArHWrVWIe5GlQU+TmojQaSx53N1iTF48zL1k90o2mXUCMX+gIdNiX5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734329160; c=relaxed/simple;
	bh=p0Ksb1HTFz6VDrCWSmQ/ZZlJ7Cscieb7L1VwQol2EXY=;
	h=Date:To:From:Subject:Message-Id; b=Hnup4yCOSjnHPb3OjsM0JoyEGwJB1DAtGpMbbtuW2UfQWtQ0Vf7vQaEB1D3TS0iNgp0sCizEEvvIfjwBjbjt1j+2OC9BGqeSp2SuyxFL455HIJWKl1zQsY+il9F+odWt4x8jFfr7xcjL9HZ7p6q/ui2IR2hsVrU4y49Vo8MjysQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nCpDJO6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nCpDJO6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287B4C4CED0;
	Mon, 16 Dec 2024 06:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734329160;
	bh=p0Ksb1HTFz6VDrCWSmQ/ZZlJ7Cscieb7L1VwQol2EXY=;
	h=Date:To:From:Subject:From;
	b=nCpDJO6ZtmxbnHvJGTDzMvlwUqfvrBECVQVTHvBvOp1FfvVZg9iJl83yJj/bF1nWn
	 k8wzYSr2yGF/y6RUd1BMX4xMAzZo+2ksGF6nIVP6HcZh+j52bly23btWAwEKD6+ODD
	 Qbv+VJUJOhbcykTfD2TlwHXVI9gGm57RRBaJwWok=
Date: Sun, 15 Dec 2024 22:05:59 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,Liam.Howlett@Oracle.com,chuck.lever@oracle.com,brauner@kernel.org,yangerkun@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch added to mm-unstable branch
Message-Id: <20241216060600.287B4C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: maple_tree: reload mas before the second call for mas_empty_area
has been added to the -mm mm-unstable branch.  Its filename is
     maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Yang Erkun <yangerkun@huawei.com>
Subject: maple_tree: reload mas before the second call for mas_empty_area
Date: Sat, 14 Dec 2024 17:30:05 +0800

Change the LONG_MAX in simple_offset_add to 1024, and do latter:

[root@fedora ~]# mkdir /tmp/dir
[root@fedora ~]# for i in {1..1024}; do touch /tmp/dir/$i; done
touch: cannot touch '/tmp/dir/1024': Device or resource busy
[root@fedora ~]# rm /tmp/dir/123
[root@fedora ~]# touch /tmp/dir/1024
[root@fedora ~]# rm /tmp/dir/100
[root@fedora ~]# touch /tmp/dir/1025
touch: cannot touch '/tmp/dir/1025': Device or resource busy

After we delete file 100, actually this is a empty entry, but the latter
create failed unexpected.

mas_alloc_cyclic has two chance to find empty entry.  First find the entry
with range range_lo and range_hi, if no empty entry exist, and range_lo >
min, retry find with range min and range_hi.  However, the first call
mas_empty_area may mark mas as EBUSY, and the second call for
mas_empty_area will return false directly.  Fix this by reload mas before
second call for mas_empty_area.

Link: https://lkml.kernel.org/r/20241214093005.72284-1-yangerkun@huaweicloud.com
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com> says:
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/maple_tree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/maple_tree.c~maple_tree-reload-mas-before-the-second-call-for-mas_empty_area
+++ a/lib/maple_tree.c
@@ -4335,6 +4335,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 {
 	unsigned long min = range_lo;
 	int ret = 0;
+	struct ma_state m = *mas;
 
 	range_lo = max(min, *next);
 	ret = mas_empty_area(mas, range_lo, range_hi, 1);
@@ -4343,6 +4344,7 @@ int mas_alloc_cyclic(struct ma_state *ma
 		ret = 1;
 	}
 	if (ret < 0 && range_lo > min) {
+		*mas = m;
 		ret = mas_empty_area(mas, min, range_hi, 1);
 		if (ret == 0)
 			ret = 1;
_

Patches currently in -mm which might be from yangerkun@huawei.com are

maple_tree-reload-mas-before-the-second-call-for-mas_empty_area.patch

