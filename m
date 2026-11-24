Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508583;
	b=sicvG6iq74jfkyMkfjYW5XjPUydIGtHAHh6ea/NsS9dXZdRLI/g4oAJ4k17Ug8/Jc89k
	 VK8RN45er+hLQLi0G/K4tQ9/wLGe/JkNzH1/v/T/SsqeipqyZQVsxsHGeSTkm2HtvZur/
	 QF+X/r2SDYaTqJ69DRlj5nq7DD8VjUrSn3uUMxkIPfKlV2QW5gCXz7rrKbqBYnF7fk7VJ
	 EymcNCZnDMMlbnBCn/kbUMnugKU9tVEXu4s8EHww61wh9Q7/KG2NAj6I5k40XoMXoTP0b
	 nCYWX/9Nw1uzuG/yJT7QnI2Iq9l9wqELEDzPCvkoIzVR+KV507kB12Dl7c91eXRBnDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508583;
	h=Received:DKIM-Signature:From:To:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=U3l/QFHwwTDxk7wEuC/PRexGWwm3sN9k+j5AiXdZEkY=;
	b=KcHzRzBIFyjwFjIRSLYkPZf2QGWubraiI2QlvRgRm2As22SKRNhUNIwkliekI7UUFLl7
	 2xDPoKoVk8cDd3aftSkDGR29tOW6KEm4z52NASu1ryyFnPJCNgZCecqFQrva4aVN5UXBv
	 vKV3J1egIsquV7VI1fIqAXzeZOvZwf88cPH6hrf7fiRg7liuznjyGZCEXW+QcvofgrCIt
	 ZSnGM519ozSv5YT9xS6KbJVV0tyxNkVzScHV4ZkRh4dhHI7qYbg3S3bWFb0tYJmb85hGX
	 YQ5xNHsyjR1hZmoIqcoGNhvSCckVDjamEAEWoK85NS7ZaOfMMwD4NoPOacHr3cuz2Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOdv+7Aa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B449606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 08:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hOdv+7Aa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BC4D1F000CF;
	Tue, 24 Nov 2026 08:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508582;
	bh=U3l/QFHwwTDxk7wEuC/PRexGWwm3sN9k+j5AiXdZEkY=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=hOdv+7Aa1uCsBJWAEEbW7Xmw82N+zdem88MjlapgQdt+xz/dLW/T9FFoCjBG9YzuV
	 vRlbfYjoc2lFYbC72zJ8Qaqywc17m3UgdoUEG6k0gOLIylRyx0qWUy577lw5ZkcBlW
	 TU0v+sUk7Irf6ScPzQwUx/cIUkCpceg+PIv+Exlw3vsN/KzAkpWItGVKpjL7YZ2C1N
	 pwfnERFTt2BWyuArKcOcRraFOH4CK38KwC3fB+GG634MwkltoCKhqQ8SsFwhjLY2iK
	 GCPtLsKdyIUzVN8I/JCl06/5bcuRR/IXPKITtdlcKwkNgGoalgPGT1Lv/VgCqSYewg
	 LHIMlCe2v3wKQ==
From: David Hildenbrand <david@kernel.org>
To: mm-commits@vger.kernel.org, vbabka@kernel.org, surenb@google.com, 
 skhan@linuxfoundation.org, shakeel.butt@linux.dev, rppt@kernel.org, 
 rmk+kernel@armlinux.org.uk, rdunlap@infradead.org, qi.zheng@linux.dev, 
 mhocko@suse.com, ljs@kernel.org, liam@infradead.org, david@kernel.org, 
 corbet@lwn.net, zhaozhengzhuo@uniontech.com, 
 Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123053858.BC7241F000CF@smtp.kernel.org>
References: <20261123053858.BC7241F000CF@smtp.kernel.org>
Subject: Re: + docs-mm-fix-stale-split-page-table-lock-references.patch
 added to mm-unstable branch
Message-Id: <179550857873.7182.5105422718163645286.b4-ty@b4>
Date: Tue, 24 Nov 2026 09:22:58 +0100
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0

On Sun, 22 Nov 2026 21:38:58 -0800, Andrew Morton wrote:
> The patch titled
>      Subject: Docs/mm: fix stale split page table lock references
> has been added to the -mm mm-unstable branch.  Its filename is
>      docs-mm-fix-stale-split-page-table-lock-references.patch
> 
> This patch will shortly appear at
>      https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-fix-stale-split-page-table-lock-references.patch
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] + docs-mm-fix-stale-split-page-table-lock-references.patch added to mm-unstable branch
      (no commit info)
[1/1] Docs/mm: fix stale split page table lock references
      https://git.kernel.org/mm/core/c/51626ff4

-- 
Cheers,

David

