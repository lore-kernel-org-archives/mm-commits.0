Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1702A391E5F
	for <mm-commits@vger.kernel.org>; Sat, 29 Aug 2026 23:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788045943; cv=none; b=FO/g0QpDyB1MR544l0CpHvHaeS5hnexelBzimoCvj1vn7mGk3yVc88M8JLvZCDQnBMAjCDSAY1LXCh2iTeK4AwCxQx1JqSsCyoGkGObCAZ5VT2oankPMsvLA5LaIIK5zei2NNBfjka2wfh+TGDdNxFAniUjRilYazD5Of4Nq60Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788045943; c=relaxed/simple;
	bh=KBkG0i8LQaBCwNrjeo0NUL0ZKD79IbWy7kqW8JyJEjU=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Fw3jA2AMCHa4/LRCGAnajWRxHos/JgsHHTpUiNIlEfHJGW3Hr2QpM2axgf3KimT9XTTW5VT81/8NvZvC0G8AL5+2Uyjs/nU+rvSoV2x8OJGSjibJpBCc5cUGH2En9DO2cDdUx0vsUtXlPfFSq8a9yMCLJkCEqjxvx+NetZL5W4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GgpGZAJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GgpGZAJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835961F000E9;
	Sat, 29 Aug 2026 23:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045941;
	bh=wKAvR5jjqebuzFJx0LpJFLBhIJxU70Erd35/Zd2eApU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GgpGZAJVUnneh7ApPrwohd9Q9ZoF7Wq/5QQyCoM6Z4Zb011Qf/sQXBvkF8wZeyX4p
	 5fzW3RPclMTcAysgtWhYmlxHNaAWA+7wC0e07S/V8Y3S0hPgZw4drWp7cSrq1OIGwf
	 GhTO2pmA/snnz0BiW9TNfCWoScsq5IdD0AQifucg=
Date: Sat, 29 Aug 2026 16:25:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Morgan <brads@mainlining.org>
Cc: mm-commits@vger.kernel.org, pmladek@suse.com, mhiramat@kernel.org,
 lance.yang@linux.dev, david.laight.linux@gmail.com, atomlin@atomlin.com
Subject: Re: +
 hung_task-reset-warning-budget-when-problem-gets-resolved.patch added to
 mm-nonmm-unstable branch
Message-Id: <20260829162541.50f77ff5de42c35b7eadffe1@linux-foundation.org>
In-Reply-To: <1C7F9139-85AC-44C5-A1D2-6C7429C84661@mainlining.org>
References: <20260829224704.C3D0B1F000E9@smtp.kernel.org>
	<1C7F9139-85AC-44C5-A1D2-6C7429C84661@mainlining.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 29 Aug 2026 23:48:39 +0100 Bradley Morgan <brads@mainlining.org> wrote:

> >Link: https://lore.kernel.org/20260829145321.18423-1-atomlin@atomlin.com
> >Link: https://lore.kernel.org/20260829145321.18423-2-atomlin@atomlin.com
> >Signed-off-by: Aaron Tomlin <atomlin@atomlin.com>
> >Suggested-by: Petr Mladek <pmladek@suse.com>
> >Suggested-by: Lance Yang <lance.yang@linux.dev>
> >Tested-by: Lance Yang <lance.yang@linux.dev>
> >Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >Cc: Bradley Morgan <brads@mainlining.org>
> 
> 
> 
> Andrewwwwww, your gonna killlll meeee but can u plssss add my taggggg.....
> My client had issues.

If you mean you want a Reviewed-by: in there then please send one!
