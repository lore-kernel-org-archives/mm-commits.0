Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3D22652B6
	for <mm-commits@vger.kernel.org>; Tue,  3 Feb 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770136025; cv=none; b=gKav8d++72kIBKqjK7aULwkc+BvA8smmM9qjzE3yOp6V3ccl3lIQ6pWhImkQMN3pIAcEOAG5im/T+O9z5Wo0bJhxEZ3zZnv9myEuoR/17pTo7KSkr5lED5CU2wN9xVgE7Mvy2bOQHH49xnrASmgAoez5kxlYczvdLsfkxo2320w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770136025; c=relaxed/simple;
	bh=hXA9Q4Yr7Rqf5D6N6MAezeq1lyu9RCN7BxAmZEqfNsE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=XMawmrDPvmd2B0mLqLIvltrVE2K9d184V8ogoQDTkpK8apMqWcGYP91z56d7uNH94wSsrFZaFYS01OQxwlySJw2qQQ7a2jUZcwLyhdLnYkmHYT1IuP9aKuMhIe9vRJsyQRDz/OU0AB0rSMkmGJwLBjRAogrcHup7+R/lspdXuLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ab3/bwWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ab3/bwWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8380C116D0;
	Tue,  3 Feb 2026 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770136024;
	bh=hXA9Q4Yr7Rqf5D6N6MAezeq1lyu9RCN7BxAmZEqfNsE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ab3/bwWNT+w82WzlTtc9aUaSffPEAIPtuZCQe81eJVvcbgSf72ali2hA8pORNXzFo
	 D7LG2A+t2lpFzD4q85SJsYZDhGYbVdGpAfhQC1wO2t3wgsl+ZThlnOo5jWNM2KzvBg
	 UFV48A9hGK67utAsyiG3zBu2CBjUWGK7Wae/WhNU=
Date: Tue, 3 Feb 2026 08:27:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, vishal.moola@gmail.com,
 songshuaishuai@tinylab.org, samuel.holland@sifive.com,
 rdunlap@infradead.org, pawan.kumar.gupta@linux.intel.com,
 palmer@dabbelt.com, mingo@kernel.org, lirongqing@baidu.com,
 leitao@debian.org, kevin.brodsky@arm.com, kees@kernel.org, fvdl@google.com,
 elver@google.com, cuiyunhui@bytedance.com, corbet@lwn.net, bp@alien8.de,
 bjorn@rivosinc.com, bhelgaas@google.com, arnd@arndb.de,
 aou@eecs.berkeley.edu, alex@ghiti.fr, ruanjinjie@huawei.com, Jinjie Ruan
 <ruanjinjie@huawei.com>, Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: Re: [merged mm-nonmm-stable]
 riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from
 -mm tree
Message-Id: <20260203082703.bae7a2b786da8d74f5ebf851@linux-foundation.org>
In-Reply-To: <aYGnODFtgjyiRLB9@kernel.org>
References: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
	<aX9jPbkG7QYNWH73@kernel.org>
	<20260202125404.343361f6696777efc3acaab1@linux-foundation.org>
	<aYGnODFtgjyiRLB9@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Feb 2026 09:43:52 +0200 Mike Rapoport <rppt@kernel.org> wrote:

> On Mon, Feb 02, 2026 at 12:54:04PM -0800, Andrew Morton wrote:
> > On Sun, 1 Feb 2026 15:29:17 +0100 Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > > > From: Jinjie Ruan <ruanjinjie@huawei.com>
> > > > Subject: riscv: kexec: add support for crashkernel CMA reservation
> > > > Date: Mon, 26 Jan 2026 16:07:38 +0800
> > > 
> > > I commented on almost identical patch for arm64 
> > > 
> > > https://lore.kernel.org/all/20260126081334.699147-1-ruanjinjie@huawei.com/
> > > 
> > > about moving the exclusion of CMA regions into the core crash code.
> > > The same comment applies to this one as well. Sorry I didn't mention that
> > > more explicitly.
> > 
> > Thanks.
> > 
> > So IIUC this patch is OK, but we should reduce the code duplication in
> > this area?
> 
> The patch is Ok in the sense it does not break anything :)

No probs, I've dropped "riscv: kexec: add support for crashkernel CMA
reservation" from mm.git.

> I'd like to see series with PATCH 1/3 moving the duplicated code from x86
> and powerpc to the crash_core.c and patches 2 and 3 adding arm64 and riscv
> support for CMA.

I'm not sure which kind soul will be doing this work!

I've cc'ed Jinjie Ruan regarding "arm64: kexec: Add support for
crashkernel CMA reservation" and Sourabh Jain regarding "powerpc/kdump:
Add support for crashkernel CMA reservation".


