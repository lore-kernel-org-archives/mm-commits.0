Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46AA5680
	for <mm-commits@vger.kernel.org>; Tue, 24 Jun 2025 02:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750733416; cv=none; b=gL3+UTX+svglpvVbF0WPxgVkB3wAOZ4pDlr4SFMMWHHnfWvyk3A/k2o7fFD4ntFj3m68JZ6X0gSYCdFsUyxKt2DJbQCH39Ocw7ta/pXjYI1Ys/GxjcUg/m2xGiRvjeB4083o0UVCveziklhZ/bEuh1VjqWNzyr3cy4PuwMVlBRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750733416; c=relaxed/simple;
	bh=/wnX62Pe3cg5usRtsrVJv+BwOnEG+KEhrlX/9DnIj3E=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=uzdVzoH1OZrztzAtisCq8EA2zkR6RpN6BeQtEuav2auwp5s/HriZaoHO/YQLwoHy8J7M7bbNfiWZV3RGwCVI3eYLxPM9h1TigajypuI4iNOZGgfiWZs0G4ACJqqhKRcHXqBW1CfWsqUXYQHAFqwyMIB/VTymFhXJQnc7NYhJ3Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qsNZMdMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qsNZMdMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC43EC4CEEA;
	Tue, 24 Jun 2025 02:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1750733415;
	bh=/wnX62Pe3cg5usRtsrVJv+BwOnEG+KEhrlX/9DnIj3E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qsNZMdMzaFXZpMd273oamnfUpgzdkzCOnK5zOnF6dxHwqJLjUl6QggyPMF6ScoyhO
	 xe+z7kTPFYW/ThXW5MzqDK0tRogPkxA6k75jIofywb51dJQrYrx4krs0BhSxMPdBg5
	 k7K2ffW79guchJVF6UmpR6fvTgHy9zMIZdkmVcx4=
Date: Mon, 23 Jun 2025 19:50:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: mm-commits@vger.kernel.org, shuah@kernel.org, ryan.roberts@arm.com,
 lorenzo.stoakes@oracle.com, keith.lucas@oracle.com, joey.gouly@arm.com,
 hannes@cmpxchg.org, david@redhat.com, dave.hansen@linux.intel.com,
 catalin.marinas@arm.com, bagasdotme@gmail.com, aruna.ramakrishna@oracle.com
Subject: Re: [failures]
 ksm_tests-skip-hugepage-test-when-transparent-hugepages-are-disabled.patch
 removed from -mm tree
Message-Id: <20250623195014.2a467bb3372e4862811ccc79@linux-foundation.org>
In-Reply-To: <CAEemH2eSWTM21dj8F7-5USHCWTvSnHqyAdxGvdpXC9xBvQVQKQ@mail.gmail.com>
References: <20250623223440.40B95C4CEEA@smtp.kernel.org>
	<CAEemH2eSWTM21dj8F7-5USHCWTvSnHqyAdxGvdpXC9xBvQVQKQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Jun 2025 08:48:00 +0800 Li Wang <liwang@redhat.com> wrote:

> What kind of failure this patch have?
> 
> If any clues are provided, I can help to debug and send a new v2.
> 

Lorenzo hit an issue:
https://lkml.kernel.org/r/f76adc25-470b-47f6-b662-22583dc8cb06@lucifer.local
