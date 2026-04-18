Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BE33161BE
	for <mm-commits@vger.kernel.org>; Sat, 18 Apr 2026 07:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776498750; cv=none; b=eyYiUCKFdm+1tSw2+IgYOw7gO0H+c3KV3SXBRtOOxTuACXl1N0mjzowy/WSVREGfbkri6jsvhZe1vvuY0D9WptPI7KLXnfOs5IfCGAmZzSNMOI+Fqd4FYCqHBtbeh0uQfrQGgP3hN+Oqyw9FynnD7lSVbHnWY4EOD14qRY4VEcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776498750; c=relaxed/simple;
	bh=/4HKZDsTPPvyUv3ZGDIigrSjM9TOAtX1txLXzyvIBNs=;
	h=Date:To:From:Subject:Message-Id; b=XoZBApviygRDzBTgj+q1RcO8DU2l0cW7XumOWS1l7t0lgVF5cCBxda7D5h/7jCViXn81n4SJZl5wvhbveCb+yN5pwnPbQHzzM4kwqleN62IZnARlPV5iMEa9S5bOx+SHsGo4X9RHP5rqPgW+9e0q9GmqggsoBtTX/JF7uLjbpDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=z39mTL3q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="z39mTL3q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3D6C19424;
	Sat, 18 Apr 2026 07:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1776498750;
	bh=/4HKZDsTPPvyUv3ZGDIigrSjM9TOAtX1txLXzyvIBNs=;
	h=Date:To:From:Subject:From;
	b=z39mTL3q6OKVPf7kYXA+ybhep7szjfg2cYqkwKwbF1CsyU6bCOHJEWOigu/uq0iJr
	 CtKGuNEymeBSSmQgHHo3UwuWUZt6XNoW2li9yKB6J22u4PUkRGN/jKSigPPNTPBy9g
	 A/vXZwKQ+ce9vZJ7xNStJ6C116QtKp5oWGoz32lE=
Date: Sat, 18 Apr 2026 00:52:19 -0700
To: mm-commits@vger.kernel.org,skhawaja@google.com,shuah@kernel.org,rppt@kernel.org,pratyush@kernel.org,dmatlack@google.com,brauner@kernel.org,pasha.tatashin@soleen.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memfd-implement-get_id-for-memfd_luo.patch removed from -mm tree
Message-Id: <20260418075229.4A3D6C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memfd: implement get_id for memfd_luo
has been removed from the -mm tree.  Its filename was
     memfd-implement-get_id-for-memfd_luo.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Subject: memfd: implement get_id for memfd_luo
Date: Thu, 26 Mar 2026 16:39:42 +0000

Memfds are identified by their underlying inode.  Implement get_id for
memfd_luo to return the inode pointer.  This prevents the same memfd from
being managed twice by LUO if the same inode is pointed by multiple file
objects.

Link: https://lore.kernel.org/20260326163943.574070-3-pasha.tatashin@soleen.com
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Cc: David Matlack <dmatlack@google.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Samiullah Khawaja <skhawaja@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Christian Brauner <brauner@kernel.org> 
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd_luo.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memfd_luo.c~memfd-implement-get_id-for-memfd_luo
+++ a/mm/memfd_luo.c
@@ -560,6 +560,11 @@ static bool memfd_luo_can_preserve(struc
 	return shmem_file(file) && !inode->i_nlink;
 }
 
+static unsigned long memfd_luo_get_id(struct file *file)
+{
+	return (unsigned long)file_inode(file);
+}
+
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
 	.finish = memfd_luo_finish,
@@ -567,6 +572,7 @@ static const struct liveupdate_file_ops
 	.preserve = memfd_luo_preserve,
 	.unpreserve = memfd_luo_unpreserve,
 	.can_preserve = memfd_luo_can_preserve,
+	.get_id = memfd_luo_get_id,
 	.owner = THIS_MODULE,
 };
 
_

Patches currently in -mm which might be from pasha.tatashin@soleen.com are

liveupdate-fix-return-value-on-session-allocation-failure.patch

