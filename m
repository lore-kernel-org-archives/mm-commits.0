Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924594C9F
	for <mm-commits@vger.kernel.org>; Fri, 31 Jan 2025 01:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738286661; cv=none; b=KJuJvciB/21thqHvFdZfn0pwUBWKIHDzvaxMgz3poRJlzRRleAUUfMsz1S6pY+Yw32qtDKIiNgyDCgHO+gyNMc1JUy633xKW7It5kyg/OUHw7JE7yyxGuz/iQ1wsOkxfPthcpLM13DJhsaHBvtesjZgyJEBgOfTr6LsCN1ZnO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738286661; c=relaxed/simple;
	bh=poyb0PG6uzqhx0aBhWZglDjGjBF+IZsn4Yhf23JDrDo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=j8rsfGT1fijBFtsBmp/eZkyrIH5Cp48n1opwGNiEWhlg8PMvjhPJtbr93oPaKzU2bQ0Kfxr9vSVMCOr7Ttd2ekmZZarVkTwEXen5QMcq17zMFFRbYlLe3YMAyVgtLeaKACNGExXqQNOAwc42WntlMaxgpGQ2QdLTpRVjIdFiuNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Er2u3FOh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Er2u3FOh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4E6C4CEE0;
	Fri, 31 Jan 2025 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738286660;
	bh=poyb0PG6uzqhx0aBhWZglDjGjBF+IZsn4Yhf23JDrDo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Er2u3FOhd6EH3B/zvADgpjMD9i4L6ov0+7Mb0b9UfjKe+Lasa41+ePjh9HEhC3Lb9
	 LFwqPWRBajQAVr4GU1cGRzQViab5jKf9XYKveN+d+qbYhEfsq814siNvOs9lBkkuvy
	 0jIUVUMENvgZePfsBWNXa17zgjkNHvPSW/17Vyj4=
Date: Thu, 30 Jan 2025 17:24:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: mm-commits@vger.kernel.org, minchan@kernel.org, Uros Bizjak
 <ubizjak@gmail.com>
Subject: Re: + zram-switch-to-non-atomic-entry-locking.patch added to
 mm-unstable branch
Message-Id: <20250130172420.b39e93b60280c48d78c7d5cd@linux-foundation.org>
In-Reply-To: <eqdrqsj5tgvbq5ocahgl3e6wog53l4fi5qjhejhklbpm5z64yb@oqrqm6vvf7vi>
References: <20250127205809.A05DDC4CED2@smtp.kernel.org>
	<eqdrqsj5tgvbq5ocahgl3e6wog53l4fi5qjhejhklbpm5z64yb@oqrqm6vvf7vi>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jan 2025 20:31:59 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:

> Would you prefer a complete re-spin of the series, with these changes
> squashed, or a "fixup" patch?

It seems that you'll be resending anyway, so the question is self-answered ;)
