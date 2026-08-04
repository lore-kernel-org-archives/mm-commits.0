Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD453F44EF
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 04:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785816326; cv=none; b=IZYwtOlMqfLsZ4pGqq4oJEBHsXkKRC9N30yau5PKoBzRHbl50ym3wnRPlMoJYvvNdMbtAAStK/0AlRuD/fzlIfbgCBS7qSf4PeykxmjtzvzpsM2Ys0IwTk7w7cmFhMgo3z0/HQt157WLDwdTDzmamyQLEY0mIxHYZmKFwQn6QVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785816326; c=relaxed/simple;
	bh=z9r3mtKX+sQdwzE6Z7wZvJ3KeOJ9MEF1CG/L56SmftQ=;
	h=Date:To:From:Subject:Message-Id; b=G89fbTUMuvaLnvE+8CjvnNYncZe7w0wFO4RH6b0LLIzsgLeYTPG6tb+g9KXtPs0H6sgYvYFjsMjs8TOm66iILmmyyjFm96dmih0J8vt657a+x8JKIa9xWCMQfD3sth5f4foj8kaQLwEgNZTNCN5DoJ5IlhgH0lV4YweSzKoQkxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tF9i4LWS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tF9i4LWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817961F000E9;
	Tue,  4 Aug 2026 04:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785816324;
	bh=fqWKS0UTtAkaZ97EKmcd7GJxFaz2yfXN9s0Cq+JI41Y=;
	h=Date:To:From:Subject;
	b=tF9i4LWSz9xkT8giyTV0EwdyW7t9D8KO4W+1CpCJjmkKIPBLMzAgiYXvkHqZUYbAC
	 mZkdk8m8EPJD4XFae6OBwnXO2sJm1ncVressMErRJoBWbuAbUxqVIu9fC9IoJg+UwW
	 cIEkAGbjmRRUpeLclMxLJuR7BjXKoQNgPnXE/DCo=
Date: Mon, 03 Aug 2026 21:05:24 -0700
To: mm-commits@vger.kernel.org,thomas.orgis@uni-hamburg.de,balbirs@nvidia.com,cyyzero16@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch removed from -mm tree
Message-Id: <20260804040524.817961F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: taskstats: return -EBADF when cgroupstats receives an invalid fd
has been removed from the -mm tree.  Its filename was
     taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yiyang Chen <cyyzero16@gmail.com>
Subject: taskstats: return -EBADF when cgroupstats receives an invalid fd
Date: Sat, 11 Jul 2026 04:07:36 +0800

Patch series "taskstats: fix cgroupstats invalid fd handling and add
selftests".

This series fixes an issue where cgroupstats mishandles invalid file
descriptors, and introduces a functional kselftest to prevent regressions.

When an invalid file descriptor is passed via CGROUPSTATS_CMD_ATTR_FD,
cgroupstats_user_cmd() returns 0 instead of an error code. This leads to
two broken behaviors depending on netlink flags:
- Callers without NLM_F_ACK block indefinitely on recv().
- Callers with NLM_F_ACK receive a misleading success ACK (errno == 0)
  but no actual statistics payload.

The first patch addresses this by returning -EBADF when the fd cannot be
resolved.  The second patch adds a comprehensive kselftest covering both
the valid cgroup v1 query and the invalid fd paths (with and without
NLM_F_ACK) to ensure the fixes work as intended.


This patch (of 2):

cgroupstats_user_cmd() returns 0 without sending a reply or a netlink
error when the fd passed via CGROUPSTATS_CMD_ATTR_FD does not resolve to
an open file in the caller's table.  As a result:

- clients that did not set NLM_F_ACK block on recv() indefinitely
  waiting for a CGROUPSTATS_CMD_NEW message that is never emitted;

- clients that set NLM_F_ACK receive a misleading "success" ACK (errno
  == 0) with no statistics payload.

Return -EBADF instead so the netlink layer propagates the error to
userspace as expected.

Link: https://lore.kernel.org/cover.1783713230.git.cyyzero16@gmail.com
Link: https://lore.kernel.org/b4fd9e288e4a48efebaf41b4ffcdb204b06675c4.1783713230.git.cyyzero16@gmail.com
Signed-off-by: Yiyang Chen <cyyzero16@gmail.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Dr. Thomas Orgis <thomas.orgis@uni-hamburg.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-return-ebadf-when-cgroupstats-receives-an-invalid-fd
+++ a/kernel/taskstats.c
@@ -423,7 +423,7 @@ static int cgroupstats_user_cmd(struct s
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	CLASS(fd, f)(fd);
 	if (fd_empty(f))
-		return 0;
+		return -EBADF;
 
 	size = nla_total_size(sizeof(struct cgroupstats));
 
_

Patches currently in -mm which might be from cyyzero16@gmail.com are


