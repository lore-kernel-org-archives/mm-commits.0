Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507C42580CF
	for <mm-commits@vger.kernel.org>; Fri,  1 May 2026 23:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777679999; cv=none; b=TX0Tc1L3NjzldgZBcPWIgcVnlI3CZ1p/mZJpam636gfnAk61qmzr/SBogBb/lh0Lk7zKMpjYbeH2Nb/PqGTm7Hl6RLUEnaNiGoXNHxIIUPizrQh01MPoB8Q38A7w6bJCHWklgENhyqUSyqs3tWG4m1c9uKG9Qdr8KlApCJ0vXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777679999; c=relaxed/simple;
	bh=Q9d12WudBYwwE6g469xbl0HpN/QTGkGa9Cfec04Ex+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef+QlfRrukoOULhX0hUH4MjuYsDTqbOqQWhWbz0tiDUmTbaxS0ls45TPh/iCP4hOqBXRig14imvj/2JF268p1HFBj0F1ACdEKvhxNz9Jzq3we0KbemyOpHlT7Z6Yk70bvMFTajV53PA6hhTyxP1xt6HQ2//FkLiSfkhEEzSgx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5/q9J85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5/q9J85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89579C2BCB4;
	Fri,  1 May 2026 23:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777679999;
	bh=Q9d12WudBYwwE6g469xbl0HpN/QTGkGa9Cfec04Ex+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V5/q9J85MMzy20t+4a8nDNa+kE8mjwwFgglxgdLkxYRa4JIJF6/AFrh6dwT5k7ybW
	 A+991EBuLPnPWmvl+QhdLOYtwZ/uiPKNHcrLF9N9OfSi3EtkiLr3pJ3OjA4LPn5FHs
	 OLFfA3XQupALgv5Q+Vy+zE54ljIp3XUH3CtgZrpU3GSR/lqXFgooADVxUJa1Lri5RG
	 2V7kEbenqcw+J5+LZpLYB75N8tXU/3HEaTIQA5Sdcoa9TIDSLUMJ5YYBxkdAHjvua3
	 EFOQxyaIi1lhlHxl4ZWxzGj5Dw2CsH6kTY5/okOdyCsuIESqQDdCTs/NKrEm5zyKye
	 /NrF4UnUa4cQw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	vbabka@suse.cz,
	tj@kernel.org,
	shakeelb@google.com,
	mhocko@kernel.org,
	longman@redhat.com,
	hannes@cmpxchg.org,
	cl@linux.com,
	li.wang@linux.dev
Subject: Re: + selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch added to mm-new branch
Date: Fri,  1 May 2026 16:59:56 -0700
Message-ID: <20260501235956.146285-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501123547.779FCC2BCB4@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 01 May 2026 05:35:46 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: selftests/cgroup: fix hardcoded page size in test_percpu_basic
> has been added to the -mm mm-new branch.  Its filename is
>      selftests-cgroup-fix-hardcoded-page-size-in-test_percpu_basic.patch
[...]
> ------------------------------------------------------
> From: Li Wang <li.wang@linux.dev>
> Subject: selftests/cgroup: fix hardcoded page size in test_percpu_basic
> Date: Fri, 1 May 2026 10:20:57 +0800
> 
> Patch series "selftests/cgroup: Fix false positive failures in
> test_percpu_basic", v2.
> 
> This patch series addresses two separate issues that cause false
> positive failures in the test_percpu_basic test within the cgroup
> kmem selftests.
> 
> The first issue stems from a hardcoded assumption about the system
> page size, which breaks the test on architectures with larger page
> sizes.
> 
> The second issue is an overly strict memory check that fails to
> account for the slab metadata allocated during cgroup creation.
> 
> 
> Thi patch (of 2):

Nit.  s/Thi/This/


Thanks,
SJ

[...]
