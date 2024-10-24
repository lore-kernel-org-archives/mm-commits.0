Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18723C47B;
	Thu, 24 Oct 2024 03:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729740461; cv=none; b=p3XV+QfC0r+WoWv5qkPci+vntXA2nzRF+z7FTCI7YxLa0vqX+EPntu8o9rWii3clewquR8aktowJ4O9Hy4PEkRlMZ08HTK1rLYIxk59OWFkRw7LzqegStxEQq9oFiV2rSTHPw0rUY54Y0VEqAS8upLgRURX46I+3CeoDBrIM1AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729740461; c=relaxed/simple;
	bh=EiQYpPigN+A7dAVfsdc3Vo6D4yOaS9eFK+xza1Fxumo=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UQ1XSpwKpw2BHhkG/gqtj65XpKUVWUJPui6DhgmtOoISx61/D/sWMOyzakM7GkB8NObu0xBLArdh75v2y4lC9yL1ayoUo//CTHsfcU98n/z1hV1CDgdQQ1H2KCiK2uBPjENVi+x7n5+2TUYMNHtSrjwj2CM6HEf/E485gBPP/4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vnj0pdvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vnj0pdvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B46EC4CEC7;
	Thu, 24 Oct 2024 03:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1729740461;
	bh=EiQYpPigN+A7dAVfsdc3Vo6D4yOaS9eFK+xza1Fxumo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vnj0pdvJCwJIl6XEPoiEBe6amdwNH0xao8q1aJhQi0o4jST1IK49lKMsk7g5skqG1
	 98lEw5IqbWegU47GOSRa7oL1iATRtFSLA5vGocF9o/3U67DBX6JwcmdrnuwSPG7ryC
	 kvktcfKaeNzxiUO2bVnHtuZvpbzRWTOFpAJ1SLxg=
Date: Wed, 23 Oct 2024 20:27:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: mm-commits@vger.kernel.org, stable@vger.kernel.org, kees@kernel.org,
 andy@kernel.org, bartosz.golaszewski@linaro.org
Subject: Re: +
 lib-string_helpers-fix-potential-snprintf-output-truncation.patch added to
 mm-hotfixes-unstable branch
Message-Id: <20241023202740.ddcdbbe38b5fd46e619e2c44@linux-foundation.org>
In-Reply-To: <601574d94d05e580548256d6c46e1d3d38c6f132.camel@HansenPartnership.com>
References: <20241024025252.BA359C4CEC6@smtp.kernel.org>
	<601574d94d05e580548256d6c46e1d3d38c6f132.camel@HansenPartnership.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Oct 2024 23:08:46 -0400 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > The output of ".%03u" with the unsigned int in range [0, 4294966295]
> > may get truncated if the target buffer is not 12 bytes.
> 
> I think we all agree the explanation isn't accurate: remainder will be
> between 0-999 (not range [0, 4294966295]) which means that the string
> will only ever be 5 bytes (including leading zero).
> 
> This might be required to correct a compiler false warning, but if it
> is applied, the patch description should say this.
> 

Thanks, I've added a note-to-self that a new version is expected.
