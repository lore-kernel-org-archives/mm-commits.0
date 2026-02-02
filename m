Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72A3156F45
	for <mm-commits@vger.kernel.org>; Mon,  2 Feb 2026 04:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770007241; cv=none; b=DmnlrxgBQI7Yfd3HCgr5+ZEN1g4bTLyCTAuHml0rQbRkoulLaxqnx68ULtBoXKxDLb2Qw3KUfSOipYSRnz90JxNL63VFMRqKd5ppKOEU7Re2d4dmQb6P77qMpqxlxWV08KchP/pjINT6bUwuMdTJrWqoF48uz07zUX9LES9V/fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770007241; c=relaxed/simple;
	bh=6h3gAP04fQOMV3uEuLLn4EKpBgKrr9x5bqHl3BLQ++Y=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Fet1a5FLS+1eZqUBaIQnwskTcCySo4EtLQM/WVMbN2eqhK7rILuSagQ051mAjhMKd4/SYA/VQrDtGesfz3tIIPHARjWYBVHe/HuX7qE2JKuwyCsVwMPAOXW8j6hRD4GGmxMD5EBGi3kBpY+MU+T4uvsL+r8ZyHTnv8HTRDbMjtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h+piS2Q1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h+piS2Q1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10769C19421;
	Mon,  2 Feb 2026 04:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770007241;
	bh=6h3gAP04fQOMV3uEuLLn4EKpBgKrr9x5bqHl3BLQ++Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h+piS2Q1RCYhcOdQ0gLxDpZFoWYptgVs4TUdB3hu3olTrXcAhvS8NuqGNDqsq6cx+
	 6hQZbzNSao73L6fA09kBEyCeHxPiHtUjak3V0q0vy3XZUIdHaQ1Cuv/lOZYmJL+JJp
	 LlsqLiQUKd0wd3m9N1pNBW24FCUjkKdKGkRmu5Gg=
Date: Sun, 1 Feb 2026 20:40:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joseph Qi <jiangqi903@gmail.com>
Cc: swilczek.lx@gmail.com, mm-commits@vger.kernel.org, Mark Fasheh
 <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, Heming Zhao
 <heming.zhao@suse.com>
Subject: Re: +
 ocfs2-fix-circular-locking-dependency-in-ocfs2_acquire_dquot.patch added to
 mm-nonmm-unstable branch
Message-Id: <20260201204040.ed94c04c02606787c1891ee7@linux-foundation.org>
In-Reply-To: <dd7c7aaa-a08a-4706-9570-b34dd313f667@gmail.com>
References: <20260131235655.23B43C4CEF1@smtp.kernel.org>
	<dd7c7aaa-a08a-4706-9570-b34dd313f667@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Feb 2026 11:01:38 +0800 Joseph Qi <jiangqi903@gmail.com> wrote:

> As discussed in v1 thread, I also have questions for this solution.

Great, thanks - I've added a note and shall take no further action on
this patch unless requested to do so.

