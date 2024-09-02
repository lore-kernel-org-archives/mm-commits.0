Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6921A3ABB
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725305727; cv=none; b=VxFVMwSBvc8VrHRyPHQSbHMpyS6fDutZagWctcJmNUIFF5rzJEAET4az7ltVihNAmsbzzh0hGA1DucuKkUR3WsjerlKh8JeQcRFhUiOtZJaqBMFJTkPB3AKSMDP9PsHxFsZ42R8O60D6jS5Ekt+roYah+P5VsjlBnE3XhtFZ7Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725305727; c=relaxed/simple;
	bh=F3o5KIHXkf1gcqlPt3kbga52VqaDk5S8OVjapHkrPmA=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=TG4UCJeMgOWy0lgI+n4V8GYd4evBZnkEpsfFRAf1NDFapYuuQ88p+/U0LmzMt9s0Cf4fKfr7npIUfAf3S5qNoxvNgy3OfgMaB8QoxefygVpzYebpIPecaHtP6shpo5v/I880iu/yI+A16y3yjCfpC7fcmsNbtF/m0ar/0Fu285E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KzmX8TYL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KzmX8TYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB5C4CEC2;
	Mon,  2 Sep 2024 19:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725305727;
	bh=F3o5KIHXkf1gcqlPt3kbga52VqaDk5S8OVjapHkrPmA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KzmX8TYLCIW2KZBrvLl1MN0J0WnNYcxlO+jojf5qQAEjGFZN/nR/1+Og+4zPO8skL
	 ONlSkwWhMcLOBzORvhYUhPypkjMl+lPREAxKf8RTDe61hM8M246hy+p9VHOOlAOrRh
	 zumAdvgu4aCSrRZtlx2GRstxjImzV1En3F/8HgII=
Date: Mon, 2 Sep 2024 12:35:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takaya Saeki <takayas@chromium.org>
Cc: mm-commits@vger.kernel.org, willy@infradead.org, uekawa@chromium.org,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Subject: Re: [merged mm-stable]
 filemap-add-trace-events-for-get_pages-map_pages-and-fault.patch removed
 from -mm tree
Message-Id: <20240902123526.37112a46daff0fd59061a955@linux-foundation.org>
In-Reply-To: <CAH9xa6eWt4nDE-1a4ZHsz9Z2e5muAYwEZ1+dJRSeKxzowhkYfA@mail.gmail.com>
References: <20240902033004.5128EC4CEC2@smtp.kernel.org>
	<CAH9xa6eWt4nDE-1a4ZHsz9Z2e5muAYwEZ1+dJRSeKxzowhkYfA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Sep 2024 18:44:45 +0900 Takaya Saeki <takayas@chromium.org> wrote:

> Hello Andrew, there is a newer v4 version for this patch.
> https://lore.kernel.org/lkml/20240816211029.903842-1-takayas@chromium.org/T/
> Do you mind letting me know how to correct the patch being merged to
> the latest version?

Send a patch against the earlier code, be sure to include

Fixes: b6273b55d885 ("filemap: add trace events for get_pages, map_pages, and fault")

