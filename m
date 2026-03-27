Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED53324B31
	for <mm-commits@vger.kernel.org>; Fri, 27 Mar 2026 23:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774653881; cv=none; b=kJ7a2MdP6CpckB+zwcIywRmB/O0kg1PweFZchJHApjRmwtclovge5Ri9ZhsvuMte3VAZWKWHVmA4H//UHivwTMFVfWVnvfqe6HDvIiQhDRYOeZ6e0weUvToQD9SJpZbVUb2mSmT9c7rl0yZ3aYcAYA0Z9DBQ3d4g4M4TrNVuTJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774653881; c=relaxed/simple;
	bh=BZCJWAUgewil1cVy19bLkYZDwL5VWM6XEKObjoUBWHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCbZ0JMpu8TK4Q15Za43yEXmdSsqovoquLPqVFhbbxQrBa1/LHiC0XfZvA9jsRuUKucOnbdCDi5u4bHu7FeX/E/mEHmzktsGAC3gLF5ms4bSiFW6sgaE9qDaZJ8XbGp4RRd1IzpZ8u6XOmhp1UeMMUR2n8STcgxMaUHASLkwAkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYK66ZKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYK66ZKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C8C19423;
	Fri, 27 Mar 2026 23:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774653881;
	bh=BZCJWAUgewil1cVy19bLkYZDwL5VWM6XEKObjoUBWHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iYK66ZKzC3dn47EFu1Lmqb/j+cxZbjeenvDqkrqp6C+oS0udmq8DLATekpKIkAxu+
	 DYvzeYrPZiQp73yis5XySa8cdm4lQ/unn8vxU30qtwjY3HZd1TGjK9Vnxii6a3slFv
	 FTSSfYXcxPD4KFjUUvG/BKU6o6KUpwkUhdvaJLHW1GIxKKhU0zGzT4ziWwIcRgUMNi
	 23cTfJWPEDe6ATpMb/eYBEMKPren2v7w5Z6VIsowMcQt+KZtW4CGk9ivoGBfWHaMpN
	 jfW8Gi8uIKtu3dAhcZuZItpDu4//XppBE7wOaDDoZ46732Qmp1vi9fRCYTsomTNIbx
	 FaiDbFJILuadw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	mm-commits@vger.kernel.org,
	rppt@kernel.org,
	pratyush@kernel.org,
	pasha.tatashin@soleen.com,
	jianghaoran@kylinos.cn,
	duanchenghao@kylinos.cn
Subject: Re: + mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch added to mm-new branch
Date: Fri, 27 Mar 2026 16:24:39 -0700
Message-ID: <20260327232439.65902-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326233911.E9AB2C116C6@smtp.kernel.org>
References: 
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello Andrew,

On Thu, 26 Mar 2026 16:39:11 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> The patch titled
>      Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
> has been added to the -mm mm-new branch.  Its filename is
>      mm-memfd-use-folio_nr_pages-for-shmem-inode-accounting.patch
[...]
> ------------------------------------------------------
> From: Chenghao Duan <duanchenghao@kylinos.cn>
> Subject: mm/memfd: use folio_nr_pages() for shmem inode accounting
> Date: Thu, 26 Mar 2026 16:47:21 +0800
> 
> Patch series "Modify memfd_luo code", v3.

Seems the "This patch (of N):" line is missed.

Not an issue for me, but just wanted to let you know since it seems it is not
your real intention.


Thanks,
SJ

[...]
