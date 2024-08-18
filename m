Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA853232
	for <mm-commits@vger.kernel.org>; Sun, 18 Aug 2024 02:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723948132; cv=none; b=XNqg7L6yVkBwTQQaslrg9QzM9lUfxQoEp3QZTJ3rws5vlRzETuyPJMh6oI6MKoaZXJI4qWF3dz4E45CvWs9uorn5QVBdlJW7cuNhLktbpIGlrRKBszSAlaoswiDiYMfRaTf3PoaHMpugkQQKHfFcEQg1xZYMmb1HJ4ZFWVEU2uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723948132; c=relaxed/simple;
	bh=Y2tr/cTRekmIFCt1u92uAAjkF0hX9bBQD+ir07s7M+Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rK/BwVEAP3OI1TvE3XrrYqs/3AJmkWi6W4veVRYsx9RR4x6KMPrfprg3G+8RMDLf56t9xIPLuKLUo28c+l6RK/tuNDqonTdo6Iu8926X6w8vQ0a1r+KZst5V2hPmZXeOJtKZs+vIUmxE/W6N54Zh/f9r8Zur0aVBeY6nUuybNrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=S1C7hCEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="S1C7hCEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F9FC116B1;
	Sun, 18 Aug 2024 02:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723948131;
	bh=Y2tr/cTRekmIFCt1u92uAAjkF0hX9bBQD+ir07s7M+Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=S1C7hCEGxQNYnmW0UHFjHzKU8O+2ywSCLxlVPrgnMuo7T8vuXGQenAW5LngHxRokH
	 4rq8aKEoCM+4v5qmH7fcvnrVjEUpvkHSG2oZOyto2fiU8ZdBQLi363ZaHVo8xGBIrL
	 Ruqc5FuTE90HYHovAqp0gk46dTXTZ269HZV096aI=
Date: Sat, 17 Aug 2024 19:28:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <mm-commits@vger.kernel.org>, <osalvador@suse.de>,
 <nao.horiguchi@gmail.com>, <linmiaohe@huawei.com>, <david@redhat.com>
Subject: Re: +
 mm-memory_hotplug-remove-head-variable-in-do_migrate_range.patch added to
 mm-unstable branch
Message-Id: <20240817192851.5ab1a05dda6bbc7087344b5b@linux-foundation.org>
In-Reply-To: <9bfdc0e4-4a82-4019-9264-00517e826096@huawei.com>
References: <20240816214256.1E93CC32782@smtp.kernel.org>
	<9bfdc0e4-4a82-4019-9264-00517e826096@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 17 Aug 2024 16:31:12 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Hi Andrew, please drop this series, patch1 has build issue(isolate_hugetlb)
> when rebase, and patch2 fix it, I will resend new patches.

Dropped, thanks.
