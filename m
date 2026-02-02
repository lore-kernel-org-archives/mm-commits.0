Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169572C08AB
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 20:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770065646; cv=none; b=APhvnaqAN+gDnRXCEq5mzXNX+KXThNNShyANV68S/b8n93jqmqqXtX9yO1d2n248c+9NbZ7Q0yoBhiZVd9o8cs7bCvLetO6KX0e5kybxVwSuP5gW6BSzoaVdO/Z/ZkVAj40HoFGLFZ0dwIXXnGF8tMwccF82QbTPP5N4RImQ1iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770065646; c=relaxed/simple;
	bh=dSUV+oTL1vAFmmnwke+2C9thFRP9ftotENMEA74Au1E=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JBuTuGXRqH8ijoMcUBVKsnfd7a+6LMD+/wl/b6YiC3R0+BMyjO14jx335G7wDE4g9Gepp4ugAKv/WpKwSIow0XHGTZThbNnsINsL+kLDcQGQWSe97QFU/WSWyuCTlhwvAQRgfQ/TutQBZoxtFsG+G88F57LCeI71+k57lzBTPKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JBGHjASz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JBGHjASz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8602C116C6;
	Mon,  2 Feb 2026 20:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770065645;
	bh=dSUV+oTL1vAFmmnwke+2C9thFRP9ftotENMEA74Au1E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JBGHjASz2+HhdWQKbPBNjkIsAzsMFi7/0m1DcJhBTxSR2s8BaXOciAXrjQkTsTnpe
	 evwo5To2CzKX0vKnBKbhUgnR6ss1Uu/9NuZYz9pFmL22+ZVB6ATkTddXbXOlcstJxS
	 iwuT2kTiPHBma4kAJtxpUNSeZWMRb6kUCKm3Eu8U=
Date: Mon, 2 Feb 2026 12:54:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: mm-commits@vger.kernel.org, vishal.moola@gmail.com,
 songshuaishuai@tinylab.org, samuel.holland@sifive.com,
 rdunlap@infradead.org, pawan.kumar.gupta@linux.intel.com,
 palmer@dabbelt.com, mingo@kernel.org, lirongqing@baidu.com,
 leitao@debian.org, kevin.brodsky@arm.com, kees@kernel.org, fvdl@google.com,
 elver@google.com, cuiyunhui@bytedance.com, corbet@lwn.net, bp@alien8.de,
 bjorn@rivosinc.com, bhelgaas@google.com, arnd@arndb.de,
 aou@eecs.berkeley.edu, alex@ghiti.fr, ruanjinjie@huawei.com
Subject: Re: [merged mm-nonmm-stable]
 riscv-kexec-add-support-for-crashkernel-cma-reservation.patch removed from
 -mm tree
Message-Id: <20260202125404.343361f6696777efc3acaab1@linux-foundation.org>
In-Reply-To: <aX9jPbkG7QYNWH73@kernel.org>
References: <20260201001710.A3CE5C4CEF1@smtp.kernel.org>
	<aX9jPbkG7QYNWH73@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 1 Feb 2026 15:29:17 +0100 Mike Rapoport <rppt@kernel.org> wrote:

> > From: Jinjie Ruan <ruanjinjie@huawei.com>
> > Subject: riscv: kexec: add support for crashkernel CMA reservation
> > Date: Mon, 26 Jan 2026 16:07:38 +0800
> 
> I commented on almost identical patch for arm64 
> 
> https://lore.kernel.org/all/20260126081334.699147-1-ruanjinjie@huawei.com/
> 
> about moving the exclusion of CMA regions into the core crash code.
> The same comment applies to this one as well. Sorry I didn't mention that
> more explicitly.

Thanks.

So IIUC this patch is OK, but we should reduce the code duplication in
this area?
