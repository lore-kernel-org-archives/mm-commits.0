Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDC9219A7D
	for <mm-commits@vger.kernel.org>; Mon, 22 Sep 2025 21:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758577114; cv=none; b=gbFtSJ3SUg1a9kUlG2Y/5+FAzUWOWauCPJb3+cZqrgd+psZ0SdcTi8buYgHaKHsAupEOFm6WO3yKqIPXDDSaqXEoP4xZCmpPlGv5qqwlIzQUZFtSexdFXS4tAXKKZYkR6BUhurgzwQqbxYJS2QULfz1lCqrHDvt3DnJPNhuLFYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758577114; c=relaxed/simple;
	bh=uOSRm+OA2dzDnk2WEZ9gZTUcPSKIZ1UdzajXr6+ealM=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TVUzsBCn1/o9E2kch0prGDNSNapBY/JW610HIxTDo+0LoEVR/TFcC0G8ep52mtuH26cYPaWtKNLFa25Qt9XpO26VATE9qPEM/f3i3dI+473OelHCaACeywUDwzHAvme5y8y8n1fhaRYkgZnDw+cQruQi6mbbzS68Wa/AIv2I3bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZGkmsJ5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZGkmsJ5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361B0C4CEF0;
	Mon, 22 Sep 2025 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758577113;
	bh=uOSRm+OA2dzDnk2WEZ9gZTUcPSKIZ1UdzajXr6+ealM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZGkmsJ5U2xzYT0oEqmtU/H7PgKkrTMZYrxGsPo+KxwudJd02zRFkhHZmUa0W1bWFv
	 076l+fcL+iw7MrjvdFmeOQ/iOGlXqPq4bZQy1mGAjCnoL4UODKJ21YL/UkDN1rDsc6
	 cStxv1AnY3lCOt+HGNWYsj94rlaefcOtTBcFqb5U=
Date: Mon, 22 Sep 2025 14:38:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: mm-commits@vger.kernel.org, zhouchengming@bytedance.com,
 yosry.ahmed@linux.dev, sj@kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org
Subject: Re: [merged mm-stable] mm-remove-unused-zpool-layer.patch removed
 from -mm tree
Message-Id: <20250922143832.f9df607b4315b9cb10bf3d36@linux-foundation.org>
In-Reply-To: <9ff74ee5-57df-4bdb-9da3-1644d8a083db@konsulko.se>
References: <20250921212316.D4DD5C4CEE7@smtp.kernel.org>
	<9ff74ee5-57df-4bdb-9da3-1644d8a083db@konsulko.se>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 12:11:21 +0200 Vitaly Wool <vitaly.wool@konsulko.se> wrote:

> On 9/21/25 23:23, Andrew Morton wrote:
> > The quilt patch titled
> >       Subject: mm: remove unused zpool layer
> > has been removed from the -mm tree.  Its filename was
> >       mm-remove-unused-zpool-layer.patch
> > 
> > This patch was dropped because it was merged into the mm-stable branch
> > of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> 
> With this change we will no longer be able to compile zsmalloc as a 
> module if zswap is enabled.

10k of .text.  Is that a big issue?

> 
> ...
>
> Are the 
> maintainers prepared to fix possible build breakages and 
> misconfigurations on some Linux distros as we move forward with this?

I hope so!
