Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE101ACEB8;
	Fri, 10 Jan 2025 23:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736553597; cv=none; b=SALkwEQBv8H9sq7wXOvy+CaB4C3ZMt63M2W/th0DYHOoAKvkPwYn2/B6KQo0su4UcLpas7FvYiThQf02Y4hARTA0Wb31CeB7ko0iKqduETyEUeFa7GnyHaaKcBNpFeC5PQxHDCK6ZyZErKbhPyCib7Y8ZcnGAzFgjIBCNVwfs+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736553597; c=relaxed/simple;
	bh=gV/pWKsID/GHYaARt61Ih/XC4/eKVn6SkKa9x63XAx0=;
	h=Date:To:From:Subject:Message-Id; b=ii5RqW6iBkFQju+opx7ua4xAgZlM6Dum9LyxIOURUSETDLk1uqrcS0GqZOUBRtMesY9kN0+SjOc+1IpeBvKVLkQZzwTI7EtEBFpM1gOWwosV9yLCZRtfwqGcpPyTp8yz+OZ88ngFE8HagHCXUKnCvX1Z5iTLWRDDTK03dYwNI/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yXiioLJ2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yXiioLJ2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E25C4CED6;
	Fri, 10 Jan 2025 23:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736553596;
	bh=gV/pWKsID/GHYaARt61Ih/XC4/eKVn6SkKa9x63XAx0=;
	h=Date:To:From:Subject:From;
	b=yXiioLJ2rFWcExyPj+3dQ8MViKlzfS2vofcSgqTzKVw9+6C+qKBdlFouk65/80ppY
	 NNJXdYfAUk5uYgyOU2TkbfOw8jd2wNOXwrjwUszxctTZwVKy3HY0UHXu37eLSgZ25r
	 5i0SNBdjKDZlEvErnYIsk7F5xRCyEyMBOwl5ZCds=
Date: Fri, 10 Jan 2025 15:59:56 -0800
To: mm-commits@vger.kernel.org,vgoyal@redhat.com,stable@vger.kernel.org,leitao@debian.org,dyoung@redhat.com,bhe@redhat.com,riel@surriel.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch added to mm-hotfixes-unstable branch
Message-Id: <20250110235956.E0E25C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: fix softlockup in __read_vmcore (part 2)
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

fs-proc-fix-softlockup-in-__read_vmcore-part-2.patch
mm-remove-unnecessary-calls-to-lru_add_drain.patch

