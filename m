Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69F0463B88;
	Mon, 28 Sep 2026 07:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581507; cv=none; b=Y7nFw5WYaKBi1XedlN/o23gVA0vrjSmoHR05Q8dBlTH/07bGwFeofMB18xpmmPA8gmnb8dB7SnAmh2x5Y027fj947+WqZdTT9+vm9UAJgR1XGayxfij7aey1kV1NboYPJ3jj86UaOeHKounqSpAi30ysnhAGHZEPeY9dmv28VLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581507; c=relaxed/simple;
	bh=eD7XniJvuHD9779J/D3BOZ66ie1Rs5fXYNvLwloK9OA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fI1UNoAlxOLRfIGEHh3bTfYjacuZWnWUapd0rxuScRzuNwH/TQVypvKGk3PoHtQWWQTeeQRzlcjkkSaEw4SuofZNOATk2nUk094sAbKTc/iPTr/PRrrJcOAB9jyNFU8pILNkHyvIagAD/+3VnvW5VwvjUoebQBi/twhSfcXg/Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lVaamqi8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVaamqi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5A41F000FF;
	Mon, 28 Sep 2026 07:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790581505;
	bh=55E+7Xyi4mRyjZvV18kG+lC5jlQq2LH0rb3Tdnf32vg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lVaamqi8MOEIqD63EMXcfX6WUtSC0+mayO++7CAbtN5Rj7XF6dFa4J3bFJZS9xUA9
	 eX0BbCOM58MtT2oHAL4U75vewBaDx54j9M67lVMa6jc9JUjRqoxqMegguF4wvPdY1V
	 Vr75Xg5+0MrMZ2roA0fVTlOZiPDE2yLQeJgKAWelgnGAvoDuQFVfDCnbUJoFCGp+TW
	 UDidlbWrzDBv8/7zWL51f63+Kqw79erWBhHPYwHn23QCmQQoGvXShmx2h0UGH1IoUt
	 Wpx7lB6J3IyDcQLHb+M+O089SXTZEYWQTMnnuA+Xz0QTYvNAo4pWz97vSCAAw2BeI0
	 109RRAMplWFfw==
Message-ID: <99023678-fd8a-4eef-8e43-a07b504e3e96@kernel.org>
Date: Mon, 28 Sep 2026 09:44:59 +0200
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-new 661/679] mmu.c:undefined reference to
 `__check_safe_pte_update'
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>
References: <202609270030.Y0QVBPmK-lkp@intel.com>
 <20260927133100.46a4f7067c79280dcf83731b@linux-foundation.org>
 <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <bao3loem52ww7aplteu4ialsb2umep6mynhofp3loamdewytxc@pexxabh7vdf4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/26 06:42, Anshuman Khandual wrote:
> On Sun, Sep 27, 2026 at 01:31:00PM -0700, Andrew Morton wrote:
>> On Sun, 27 Sep 2026 00:32:54 +0800 kernel test robot <lkp@intel.com> wrote:
>>
>>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
>>> head:   b4fc90c82982d98959af08b4320420bcfc01303b
>>> commit: 2862bcaf1aca55e0b43a5692a4595281ab780f05 [661/679] arm64/mm: move __check_safe_pte_update()
>>> config: arm64-randconfig-1002-20260926 (https://download.01.org/0day-ci/archive/20260927/202609270030.Y0QVBPmK-lkp@intel.com/config)
>>> compiler: aarch64-linux-gcc (GCC) 8.5.0
>>
>> Thanks.  It works for me, but I'm using gcc-15.2.0.
> 
> Tried building this series with a cross compiler (gcc 14.3.1) and a native
> compiler (15.2.0). The series builds successfully in both cases.

I'm getting the same problems building mm-next.

The following seems to fix it, which I will carry in for-next and for-test today.


From 448f146f16394713b28295236588ccab3a173827 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 28 Sep 2026 09:42:06 +0200
Subject: [PATCH] fixup: arm64/mm: move __check_safe_pte_update()

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index e589fb00d1e3..7343ac9294f8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2392,6 +2392,7 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)

 	return 0;
 }
+#endif

 /*
  * PTE bits configuration in the presence of hardware Dirty Bit Management
@@ -2440,4 +2441,3 @@ void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
 		     __func__, pte_str_old, pte_str);
 }
 #endif /* CONFIG_DEBUG_VM */
-#endif
--
2.55.0

-- 
Cheers,

David
