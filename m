Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B652571D6;
	Wed, 23 Apr 2025 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745369309; cv=none; b=ZIx/I2XQyPa2YtnAdg1V19EQS8jfTQnOTop/1DjRTZ0fBeEkOUUsy1OtHX2f2uh9CAfaAOfgWfF+GMn2DV05AXiusueHpn+PGyTvQ/IVBFhj2ls9a7QnSORZ/9yg/Ih9oACJo/Luve1dV0vXLnPO9CIkO4c90DYTnIZWifmN04U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745369309; c=relaxed/simple;
	bh=islINkURThcERiBYx+dyorrTuWeKO6IINTpeyErVlZc=;
	h=Date:To:From:Subject:Message-Id; b=OFiQn04PI7eEquyXeIKDU1YYIPLuP6q4TUtAZLoi8mZEak5mPqCnwOVG2SPEFOxHaKQ7ymW4rwzBeAg1WoBUAEVoTf4JwSJNeiqUanl/XeWLbCZtIOjO8EPY3aXAf0ix0oa8M0H6dxBzYlnCBzd7EGHyRcRoqy4Cu5Tuq8gxi+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ogg5a4fG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ogg5a4fG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EA7C4CEE9;
	Wed, 23 Apr 2025 00:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745369308;
	bh=islINkURThcERiBYx+dyorrTuWeKO6IINTpeyErVlZc=;
	h=Date:To:From:Subject:From;
	b=ogg5a4fGNtsu371Y82iD93RX6w84QfdHL1nu77IOGkbciuHZHZHFIwHwK0dNCGTad
	 eU1VHaGONk7lzJDOJMQ6DLtl3EHmEqwJF0ZUOIPaFipzmUuGwlNSxhnPmnVe5NlwMw
	 Hx+qAMvqvB0XrOoimFt9mmkmEN92PruWuzItdhQg=
Date: Tue, 22 Apr 2025 17:48:28 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,piaojun@huawei.com,mark@fasheh.com,junxiao.bi@oracle.com,jlbec@evilplan.org,gechangwei@live.cn,mark.tinguely@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [obsolete] ocfs2-fix-panic-in-failed-foilio-allocation.patch removed from -mm tree
Message-Id: <20250423004828.C7EA7C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: ocfs2: fix panic in failed foilio allocation
has been removed from the -mm tree.  Its filename was
     ocfs2-fix-panic-in-failed-foilio-allocation.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Mark Tinguely <mark.tinguely@oracle.com>
Subject: ocfs2: fix panic in failed foilio allocation
Date: Thu, 10 Apr 2025 14:56:11 -0500

In commit 7e119cff9d0a ("ocfs2: convert w_pages to w_folios") the chunk
page allocations became order 0 folio allocations.  If an allocation
failed, the folio array entry should be NULL so the error path can skip
the entry.  In the port it is -ENOMEM and the error path panics trying to
free this bad value.

Link: https://lkml.kernel.org/r/150746ad-32ae-415e-bf1d-6dfd195fbb65@oracle.com
Fixes: 7e119cff9d0a ("ocfs2: convert w_pages to w_folios")
Signed-off-by: Mark Tinguely <mark.tinguely@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ocfs2/aops.c~ocfs2-fix-panic-in-failed-foilio-allocation
+++ a/fs/ocfs2/aops.c
@@ -1071,6 +1071,7 @@ static int ocfs2_grab_folios_for_write(s
 			if (IS_ERR(wc->w_folios[i])) {
 				ret = PTR_ERR(wc->w_folios[i]);
 				mlog_errno(ret);
+				wc->w_folios[i] = NULL;
 				goto out;
 			}
 		}
_

Patches currently in -mm which might be from mark.tinguely@oracle.com are


