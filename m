Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811A336894B
	for <mm-commits@vger.kernel.org>; Mon,  9 Mar 2026 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773088991; cv=none; b=q1yGhJiDJFLby22/bLIlC5nx9zJpV9bexLmhXrgSxEzFxNu9uda/8ZZJmfsWyVdS7TBlXGcKHRJGfZlsumk2M/zsiPqAV6qDjlgA/5MSrnndaH9+V76EOEondQFzjAom6LS9bpLBSMSPUrkQ0EruutbZ8JnRwtoOIh+wPju5H8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773088991; c=relaxed/simple;
	bh=mmN2tiI+1cILfZ5uhN2WBk6AjFigAcQvLjuaZLEJqCE=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=HZ0wkvnuQEmPcqCwKpaTwlQx5TAjPnPlg+CNVm4hw+JtFnp/iMyf4D0l4gjvdCSUTd1L9uMMUyxcyas2PQp6va4R72XR9YVmlAHP/jL2GHaP7rAKR4YrxSSFPPOY2Ox6Wa/D9xc44FE8M+5/785RUflfbj9NwsXffkd2Iw0mx08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Dv4Ua3KS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Dv4Ua3KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA49BC4CEF7;
	Mon,  9 Mar 2026 20:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773088991;
	bh=mmN2tiI+1cILfZ5uhN2WBk6AjFigAcQvLjuaZLEJqCE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Dv4Ua3KSV1g/4c6ccg2aOuWMvJHYrhepmhpsX02zeO5CkBhX7c8C2SRArgmHzKjcf
	 D3A/DMTuGKOmH70Q6qBuQNREjqYV5lJy0Cy2wdFcVemmnCgRTX08ktv28aqULJfAHA
	 wmC+fcxfHeVuztF62NPqDOcJIeASCMKK41SeyP/w=
Date: Mon, 9 Mar 2026 13:43:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Law <hlcj1234567@gmail.com>
Cc: mm-commits@vger.kernel.org, objecting@objecting.org
Subject: Re: +
 lib-ts_kmp-fix-integer-overflow-in-pattern-length-calculation.patch added
 to mm-nonmm-unstable branch
Message-Id: <20260309134310.6036ef100f81a943f0fe6e2b@linux-foundation.org>
In-Reply-To: <2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com>
References: <20260309202433.1ED14C4CEF7@smtp.kernel.org>
	<2583e57b-fb3e-4e43-9d93-a3db4c816c11@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Mar 2026 20:35:07 +0000 Josh Law <hlcj1234567@gmail.com> wrote:

> Do you think these patches require Cc: stable?
> Idk the severity of the bug to you, the swapped arguments got Cc stable,=
=A0 overflow could cause some screwy bugs

Probably not - is there any reason to believe any callers will hit this?

