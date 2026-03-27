Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC8933D4F2
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 23:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774654330; cv=none; b=exyNKQ6ZVLLJmQ315qEt0Pf2H+Ga1rsRHodmUb3iz48WrRw96O5QOelOVohBojFK9gZqjFnfLUTip5pJu23oDXuHV7OohdxnxYBjOfncZ+Q/qydOT5TCsjtxIoFhoI89mypXwswQUElGZmK9Y+gQMgmDSThOSa/Em11mrH7fGbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774654330; c=relaxed/simple;
	bh=hSxjXfrhPo3bJa/w3vBME44FaxAZr6+qx2RhZtJBcE4=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=rDBr3UDWxo/ycZcDHvyxzYzPEbRx+8CIkb7Ueg8BXZ53Mjqt+3ybPMK/IxLy8XxM4f2+UAnH2IKcM+EIoXQqdx0yrMXPV0SU/5+7JSPLVyU6ms2YJIHu/A5qLZz/xI3XI19Akm4osGwlVEkicu4A74iWEhGirZFh4IhiF9ex2cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rWXZBB7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rWXZBB7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB7EC19423;
	Fri, 27 Mar 2026 23:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774654330;
	bh=hSxjXfrhPo3bJa/w3vBME44FaxAZr6+qx2RhZtJBcE4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rWXZBB7ReK5d3jFFcxQFZgeq6vCrKu7OaVoXrDIMM9k1dLjVsmXo6oJF29hqi/EEV
	 rWjvLoYAWbhwksJVns6wII3z10uw3390tcQM/C5cKFWFbYles55sfxqhm7GoANSzj1
	 ukQzckXMvbNCV+5KnDveRtDxO+5THZLjn/y1BW30=
Date: Fri, 27 Mar 2026 16:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: mm-commits@vger.kernel.org, rppt@kernel.org, pratyush@kernel.org,
 pasha.tatashin@soleen.com, jianghaoran@kylinos.cn, duanchenghao@kylinos.cn
Subject: Re: + mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
 added to mm-new branch
Message-Id: <20260327163209.f8087931130ec1d02912d407@linux-foundation.org>
In-Reply-To: <20260327232439.65902-1-sj@kernel.org>
References: <20260326233911.E9AB2C116C6@smtp.kernel.org>
	<20260327232439.65902-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 27 Mar 2026 16:24:39 -0700 SeongJae Park <sj@kernel.org> wrote:

> > From: Chenghao Duan <duanchenghao@kylinos.cn>
> > Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
> > Date: Thu, 26 Mar 2026 16:47:21 +0800
> > 
> > Patch series "Modify memfd_luo code", v3.
> 
> Seems the "This patch (of N):" line is missed.

grr, thanks.

	if grep -q "^Patch series" $p ; then
		if ! grep -q "^This patch " $p; then
			echo $p: "This patch"
		fi
	fi

there, plugged.
