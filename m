Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF72D4315A;
	Mon, 13 Jan 2025 03:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736737468; cv=none; b=i334GThIZwCnoBYcPOhItOwjB9YAK8kNry62bvTYD83xwDr9oqMef/tHLH5T09gpylrDjFGqVnCXjiU02Ycz7v5aQoG9r0jLLuxeFQF0deNDsEJ1BaFba8bqvnIZaQCZXqUzXkcYoVcDj15secCOWdz4nNgxNFlPXniFFQAACxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736737468; c=relaxed/simple;
	bh=mYLJlp3iIWRC5nkLYj1i/AIh5kXsvon3/HueGBTlfwc=;
	h=Date:To:From:Subject:Message-Id; b=DhUL8gmflUBpg02XsUvS9/eD2d7+IO9uJZJYBzfD0Rb6pX7SvxCLqwOu67QAd3r7Ume+91VhK9lKcYsuYmFAK5w7A484IiBB9BvddB5wle4QYhE05zc58aH3fcE6CYjRL2MeEi9kkeRMCJ/Ofhnmmbi5TFrSGot2+jEQMXaC0xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bQF/+WT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQF/+WT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830F2C4CEE0;
	Mon, 13 Jan 2025 03:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736737468;
	bh=mYLJlp3iIWRC5nkLYj1i/AIh5kXsvon3/HueGBTlfwc=;
	h=Date:To:From:Subject:From;
	b=bQF/+WT/zps6Fog6vr7SEpNF9q65Vuy6XbZDYWhq8TFC8TD2omsDs2gudsr/lsQ11
	 WgBfJgaXYlCBOuOOh9VszA5Cad4UdEeNknthXBVYkSulyLnGgnqvZR8o52S5XeDt9F
	 Zv1Gmqw1gg4aDepr9W3T8rptNELmSnl1+610fCF4=
Date: Sun, 12 Jan 2025 19:04:28 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,leitao@debian.org,dyoung@redhat.com,bhe@redhat.com,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch removed from -mm tree
Message-Id: <20250113030428.830F2C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: fix softlockup in __read_vmcore (part 2)
has been removed from the -mm tree.  Its filename was
     fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Rik van Riel <riel@surriel.com>
Subject: fs/proc: fix softlockup in __read_vmcore (part 2)
Date: Fri, 10 Jan 2025 10:28:21 -0500

Since commit 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore") the
number of softlockups in __read_vmcore at kdump time have gone down, but
they still happen sometimes.

In a memory constrained environment like the kdump image, a softlockup is
not just a harmless message, but it can interfere with things like RCU
freeing memory, causing the crashdump to get stuck.

The second loop in __read_vmcore has a lot more opportunities for natural
sleep points, like scheduling out while waiting for a data write to
happen, but apparently that is not always enough.

Add a cond_resched() to the second loop in __read_vmcore to (hopefully)
get rid of the softlockups.

Link: https://lkml.kernel.org/r/20250110102821.2a37581b@fangorn
Fixes: 5cbcb62dddf5 ("fs/proc: fix softlockup in __read_vmcore")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reported-by: Breno Leitao <leitao@debian.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/proc/vmcore.c~fs-proc-fix-softlockup-in-__read_vmcore-part-2
+++ a/fs/proc/vmcore.c
@@ -404,6 +404,8 @@ static ssize_t __read_vmcore(struct iov_
 			if (!iov_iter_count(iter))
 				return acc;
 		}
+
+		cond_resched();
 	}
 
 	return acc;
_

Patches currently in -mm which might be from riel@surriel.com are

mm-remove-unnecessary-calls-to-lru_add_drain.patch

