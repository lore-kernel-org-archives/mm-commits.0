From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: + mm-swap-add-cluster-lock-v5.patch added to -mm tree
Date: Wed, 18 Jan 2017 12:23:54 -0800
Message-ID: <20170118122354.9b06459e2588e53b537ca78c__28362.9293706783$1484771627$gmane$org@linux-foundation.org>
References: <587eaca3.MRSwND8OEi+lF+VH%akpm@linux-foundation.org>
        <20170118083731.GF7015@dhcp22.suse.cz>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57048 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752267AbdARUdf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2017 15:33:35 -0500
In-Reply-To: <20170118083731.GF7015@dhcp22.suse.cz>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, ak@linux.intel.com, borntraeger@de.ibm.com, corbet@lwn.net, dave.hansen@intel.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, kirill.shutemov@linux.intel.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@linux.intel.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org, linux-mm@kvack.org

On Wed, 18 Jan 2017 09:37:31 +0100 Michal Hocko <mhocko@kernel.org> wrote:

> On Tue 17-01-17 15:45:39, Andrew Morton wrote:
> [...]
> > From: "Huang\, Ying" <ying.huang@intel.com>
> > Subject: mm-swap-add-cluster-lock-v5
> 
> I assume you are going to fold this into the original patch. Do you
> think it would make sense to have it in a separate patch along with
> the reasoning provided via email?

It should be OK - the v5 changelog (which I shall use for the folded
patch, as usual) has

: Compared with a previous implementation using bit_spin_lock, the
: sequential swap out throughput improved about 3.2%.  Test was done on a
: Xeon E5 v3 system.  The swap device used is a RAM simulated PMEM
: (persistent memory) device.  To test the sequential swapping out, the test
: case created 32 processes, which sequentially allocate and write to the
: anonymous pages until the RAM and part of the swap device is used.

