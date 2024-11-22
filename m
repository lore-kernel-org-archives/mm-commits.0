Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1774015B987;
	Fri, 22 Nov 2024 06:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732255723; cv=none; b=fLF3ldM0WvmKbM+8iuLgCvyC+/A4AlaezBeEfqMCc0b+uE4EfAle/wnODxcT2Bq1Prrp8TH0myzAjQODED2tUCSB4a+Ut+kzdsKvek8CcluObKN9bWRuJaf7fS8JWxSizc/KBy7QiifE4ngJszSskclfbXDa5GT0kYAeOm+OLyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732255723; c=relaxed/simple;
	bh=9mKUJohO1l3O0imHO+wfWSUfsGrZ/p3AQqs7idxxhTw=;
	h=Date:To:From:Subject:Message-Id; b=VC8RrOGlmwfTCIJbbI5U4Q3fGW9/7+EYNDq8IKYKDNkMU6DavKYw+wsGzV8B5rKJaa4hO3kWc09H8cPA3faJZfwE6ArSBt+2p5HPE+IocboUW7mJVsCjOEmCmKqimWj6fHhNKt78HP++MNbZ1iKZO4x+vgD+JM7WSif13+QjSDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kekjc3WW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kekjc3WW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B63CC4CECE;
	Fri, 22 Nov 2024 06:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732255722;
	bh=9mKUJohO1l3O0imHO+wfWSUfsGrZ/p3AQqs7idxxhTw=;
	h=Date:To:From:Subject:From;
	b=kekjc3WWBrz0vQpCLEOS/ZicT41VdzYZOp15oHpb5dhYunFOwe5/19/O0UyCs8Pve
	 O8ht4xA7nsLQnXmXfBva2zS1gYVXq3EGM8XTLILt8W0/nuDuDxrRYtAtTsgsGQtiEs
	 PRrRv1HSptP7BXJ/Z/fv5n6BMYEQ9e//9t/6PqmY=
Date: Thu, 21 Nov 2024 22:08:37 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hca@linux.ibm.com,brauner@kernel.org,agordeev@linux.ibm.com,jolsa@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch added to mm-hotfixes-unstable branch
Message-Id: <20241122060841.7B63CC4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/kcore.c: clear ret value in read_kcore_iter after successful iov_iter_zero
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch

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
From: Jiri Olsa <jolsa@kernel.org>
Subject: fs/proc/kcore.c: clear ret value in read_kcore_iter after successful iov_iter_zero
Date: Fri, 22 Nov 2024 00:11:18 +0100

If iov_iter_zero succeeds after failed copy_from_kernel_nofault, we need
to reset the ret value to zero otherwise it will be returned as final
return value of read_kcore_iter.

This fixes objdump -d dump over /proc/kcore for me.

Link: https://lkml.kernel.org/r/20241121231118.3212000-1-jolsa@kernel.org
Fixes: 3d5854d75e31 ("fs/proc/kcore.c: allow translation of physical memory addresses")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/proc/kcore.c~fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero
+++ a/fs/proc/kcore.c
@@ -600,6 +600,7 @@ static ssize_t read_kcore_iter(struct ki
 					ret = -EFAULT;
 					goto out;
 				}
+				ret = 0;
 			/*
 			 * We know the bounce buffer is safe to copy from, so
 			 * use _copy_to_iter() directly.
_

Patches currently in -mm which might be from jolsa@kernel.org are

fs-proc-kcorec-clear-ret-value-in-read_kcore_iter-after-successful-iov_iter_zero.patch

