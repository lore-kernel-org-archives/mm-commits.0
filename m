Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A221E0B7
	for <mm-commits@vger.kernel.org>; Wed, 23 Apr 2025 22:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745448059; cv=none; b=tMxRZuAC9nkAUklk2cjSUgWnA6Vr2uNRxHCRaVhHORgx6wtHe1DmrieDjdFNsXCIipFYlIrGUHIohmSgvsK8oKPtCXbWSxCz04C56n25aAgLt77BhmjCPOVaSis/VFPrlt4sMC89gBy5Ui5xnmhxmTO5EILlMMdfm4O7dY2w9tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745448059; c=relaxed/simple;
	bh=4yjP9Cz+o/GTK5xlwmkLsfM87BRismOoFE/YZogknFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iucVZIu8kqOXNm6B9/EfVV6SYUkeZTryT3EyObKKQPmGcS0oZ1tCfTmIkwNub3cyYaJzU7tfzB1xkaj5aKav8vfSZWrp7VWGMufqJTOWv6Hh7O9CeqXwUKr+nApGYN3yHKp2D87bEuqKXNgXcPKD+wQctfBxa03vNZgy6va5kbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSoIC/XO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSoIC/XO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3B3C4CEE2;
	Wed, 23 Apr 2025 22:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745448059;
	bh=4yjP9Cz+o/GTK5xlwmkLsfM87BRismOoFE/YZogknFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSoIC/XOTlqOBLw+OwqIe+ZE4MoMSVOsVLdG93SqAue/z4V5Fm9ShW/nldhbQrLv3
	 grVVUDBAi0Tgw8yz4yaX+fQxglngheqoHmrF1SsjqveX9HRTRL4gAsK8glypkPXERw
	 lIXz3AWeVHh+iuJ7RGRVg5cFVngq5eNGUBV1AbxdvHV0qfS2dyEcF9KupQC46nvMb3
	 g28JJuMrOu4UmvL2iPO1yTo+CO9IU4AphDBra/j6PxstgIDaey3K/ZIpRCJt3JUtoS
	 D2l52dW0cKVx4MTOHPsdGUYFrudUcCPDuEbuojbSEfv8qluuwA8LX8EqTkauksxzBp
	 yQk1T8jgBxYow==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	suhui@nfschina.com,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [withdrawn] mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch removed from -mm tree
Date: Wed, 23 Apr 2025 15:40:56 -0700
Message-Id: <20250423224056.46106-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250423222109.CB628C4CEE2@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Andrew,

On Wed, 23 Apr 2025 15:21:09 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The quilt patch titled
>      Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> has been removed from the -mm tree.  Its filename was
>      mm-damon-sysfs-schemes-using-kmalloc_array-and-size_add.patch
> 
> This patch was dropped because it was withdrawn
> 
> ------------------------------------------------------
> From: Su Hui <suhui@nfschina.com>
> Subject: mm/damon/sysfs-schemes: use kmalloc_array() and size_add()
> Date: Mon, 21 Apr 2025 14:24:24 +0800
> 
> It's safer to use kmalloc_array() and size_add() because it can prevent
> possible overflow problem.
> 
> Link: https://lkml.kernel.org/r/20250421062423.740605-1-suhui@nfschina.com
> Signed-off-by: Su Hui <suhui@nfschina.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Dan did mention "No need to change"[1], but I think that means this patch needs
no additional change, and hence nobody really asked withdrawal of this patch.

Cc-ing Dan and Christophe to make it clear.  Please let me know if I'm
misunderstanindg something.

[1] https://lore.kernel.org/all/fd372c23-1bf7-4c93-a51d-ba5dad255b04@stanley.mountain/


Thanks,
SJ

[...]
