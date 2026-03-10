Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427873E1D05
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 20:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773173525; cv=none; b=ftfzWuJBu9io9lQreKo4QiXPBHgECDnA3DugZOaBVrWTpazIou5oczBaWAzi129HnupR7qQDbizCXsiVsTUwdUNG105Qjf75hRby90JzlhyYZ+UC1WwPePUtCaAohi/t36tFFrWXGazVSZjceZZvXKUE+U9HCKmbowoZIIfnV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773173525; c=relaxed/simple;
	bh=uC2+ObaW1fF867gFmFF20zzqE9pv12oYZnF3AYq58GU=;
	h=Date:To:From:Subject:Message-Id; b=q8hKAZMBaE2yGvA3bPjdppGzUOvxnNi2diMtpV8PQheDLo72O+x4wfxaqsq0qbEYngBFCJdipDfx177G/cJPMzSkJXjNwZI2z6dDmr9IKZmMkVEettUKOdSzPfKtS+P+cj4FeVA88bNNiTcyNZBn8XLIQk8hM/dXkhT+UYqc0YA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Omo+fTRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Omo+fTRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F142EC19423;
	Tue, 10 Mar 2026 20:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773173525;
	bh=uC2+ObaW1fF867gFmFF20zzqE9pv12oYZnF3AYq58GU=;
	h=Date:To:From:Subject:From;
	b=Omo+fTRWoEitR3345EnjYUpmiCQzIQkYyfa3S9s4dEx1HODO7O9QuMl//eaJUsshP
	 W4DmTGLX1hkN/MPEb2KZeUNKWxhDsIOzluXD1DYbNKQFqLjRvXh4Op4KwN6DM8xOIy
	 3hdhx999ubLTCUWeHk9neKRmgsqfj0WJcsNWfdO8=
Date: Tue, 10 Mar 2026 13:12:04 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,rppt@kernel.org,oleg@redhat.com,neil@brown.name,mingo@kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,ebiederm@xmission.com,bvanassche@acm.org,brauner@kernel.org,ethantidmore06@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] proc-fix-pointer-error-dereference.patch removed from -mm tree
Message-Id: <20260310201204.F142EC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: fix pointer error dereference
has been removed from the -mm tree.  Its filename was
     proc-fix-pointer-error-dereference.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ethan Tidmore <ethantidmore06@gmail.com>
Subject: proc: fix pointer error dereference
Date: Thu, 19 Feb 2026 16:10:01 -0600

The function try_lookup_noperm() can return an error pointer.  Add check
for error pointer.

Detected by Smatch:
fs/proc/base.c:2148 proc_fill_cache() error:
'child' dereferencing possible ERR_PTR()

Link: https://lkml.kernel.org/r/20260219221001.1117135-1-ethantidmore06@gmail.com
Fixes: 61a28784028e ("[PATCH] proc: Remove the hard coded inode numbers")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bart van Assche <bvanassche@acm.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: NeilBrown <neil@brown.name>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/proc/base.c~proc-fix-pointer-error-dereference
+++ a/fs/proc/base.c
@@ -2128,6 +2128,9 @@ bool proc_fill_cache(struct file *file,
 	ino_t ino = 1;
 
 	child = try_lookup_noperm(&qname, dir);
+	if (IS_ERR(child))
+		goto end_instantiate;
+
 	if (!child) {
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wq);
 		child = d_alloc_parallel(dir, &qname, &wq);
_

Patches currently in -mm which might be from ethantidmore06@gmail.com are


